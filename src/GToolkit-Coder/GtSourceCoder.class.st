"
!Source coder
Is a language agnostic model of a source coder.
My subclasses extend my by adding support for a specific language.
!! Code execution
To add support for code execution the subclasses must implement
- ${method:GtSourceCoder>>#evaluationRequester}$.
- ${method:GtSourceCoder>>#evaluationRequesterWithInterval}$.
- ${method:GtSourceCoder>>#primitiveEvaluate:requester:onFailDo:}$.
!! Code debugging
To add support for code debugging the subclasses must implement
- ${method:GtSourceCoder>>#debug:}$

"
Class {
	#name : #GtSourceCoder,
	#superclass : #GtTextualCoder,
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #'api - actions' }
GtSourceCoder >> debug [
	self debug: self currentSourceString
]

{ #category : #'private - actions' }
GtSourceCoder >> debug: aString [
	self subclassResponsibility
]

{ #category : #'api - actions' }
GtSourceCoder >> discardChanges [
	"Discard not-accepted changes."

	self isModified
		ifFalse: [ ^ self ].

	self sourceCode resetCollapsedText.
	self sourceCode resetSourceText.

	self sourceChanged
]

{ #category : #'api - actions' }
GtSourceCoder >> doItAll [
	"Evaluate the whole source code in a default evaluation context and return the result.
	See the implementation of #evaluationContext to find the default state"

	^ self doItInContext: self evaluationContext
]

{ #category : #'api - actions' }
GtSourceCoder >> doItAndGo [
	"Evaluate and inspect the whole source code in a default evaluation context and return the result.
	See the implementation of #evaluationContext to find the default state"

	^ self doItAndGoInContext: self evaluationContext
]

{ #category : #'api - actions' }
GtSourceCoder >> doItAndGoInContext: aGtSourceCoderEvaluationContext [
	^ self
		evaluate: [ :thisCoder | thisCoder currentSourceString ]
		inContext: aGtSourceCoderEvaluationContext
		thenDo: [ :anEvaluationResult |
			self notifyEvaluatedWithResult: anEvaluationResult.
			self notifyObjectSpawnFromEvaluationResult: anEvaluationResult ]
]

{ #category : #'api - actions' }
GtSourceCoder >> doItInContext: aGtSourceCoderEvaluationContext [
	^ self
		doItInContext: aGtSourceCoderEvaluationContext
		thenDo: [ :aResult | self notifyEvaluatedWithResult: aResult ]
]

{ #category : #'api - actions' }
GtSourceCoder >> doItInContext: aGtSourceCoderEvaluationContext thenDo: aBlock [
	^ self
		evaluate: [ :thisCoder | thisCoder currentSourceString ]
		inContext: aGtSourceCoderEvaluationContext
		thenDo: aBlock
]

{ #category : #'private - actions' }
GtSourceCoder >> evaluate: aSourceStringOrBlock [
	"Evaluate a given source code and show the print string if needed"

	^ self
		evaluate: aSourceStringOrBlock
		thenDo: [  ]
]

{ #category : #'private - actions' }
GtSourceCoder >> evaluate: aSourceStringOrBlock decorated: aSourceCodeDecorator inContext: aSourceCoderEvaluationContext thenDo: aThenBlock [
	"Evaluate a given source code"
	| aSourceString aSourceInterval aResult aDecoratedSourceString |
	
	"we can not wrap everything in a critical: because if there is an exception while evaluating
	the source code the current running process will be suspended, meaning that the very next evaluation
	will indefinitely wait when trying to enter a critical section."
	self critical: [
		| aCompleteSourceString |
		aCompleteSourceString := aSourceStringOrBlock isClosure
			ifTrue: [ aSourceStringOrBlock cull: self ]
			ifFalse: [ aSourceStringOrBlock ].

		aSourceString := aSourceCoderEvaluationContext sourceInterval computeSourceString: aCompleteSourceString.
		aSourceInterval := aSourceCoderEvaluationContext sourceInterval computeSourceInterval: aCompleteSourceString ].

	aDecoratedSourceString := aSourceCodeDecorator value: aSourceString.
	
	aSourceCoderEvaluationContext
		sourceString: aSourceString;
		evaluatedInterval: aSourceInterval.

	aResult := self evaluateBlock: [ 
		self
			primitiveEvaluate: aDecoratedSourceString
			inContext: aSourceCoderEvaluationContext
			onFailDo: [
				| aResultWithSyntaxError |

				aResultWithSyntaxError := GtSourceCoderEvaluationResultWithSyntaxError new
					evaluationContext: aSourceCoderEvaluationContext.
				aThenBlock cull: aResultWithSyntaxError.
				^ aResultWithSyntaxError ] ]
		onErrorDo: [ :aResultWithError |
			aResultWithError
				evaluationContext: aSourceCoderEvaluationContext ].

	aResult evaluationContext: aSourceCoderEvaluationContext.
	aThenBlock cull: aResult.
	^ aResult
]

{ #category : #'private - actions' }
GtSourceCoder >> evaluate: aSourceStringOrBlock inContext: aGtSourceCoderEvaluationContext thenDo: aThenBlock [
	^ self
		evaluate: aSourceStringOrBlock
		decorated: [ :aSourceString | aSourceString ]
		inContext: aGtSourceCoderEvaluationContext
		thenDo: aThenBlock
]

{ #category : #'private - actions' }
GtSourceCoder >> evaluate: aSourceStringOrBlock thenDo: aThenBlock [
	"Evaluate a given source code and show the print string if needed"

	^ self
		evaluate: aSourceStringOrBlock
		inContext: self evaluationContext
		thenDo: aThenBlock
]

{ #category : #'private - actions' }
GtSourceCoder >> evaluateBlock: aBlock onErrorDo: anErrorBlock [
	<return: #GtSourceCoderEvaluationResult>
	| aResult wasErrorAlreadySignaled |
	
	wasErrorAlreadySignaled := false.
	aResult := aBlock
		on: Error
		do: [ :anError |
			| aResultWithError |

			NonInteractiveTranscript stdout
				nextPut: $[;
				nextPutAll: self class name;
				nextPut: $];
				space;
				print: anError;
				cr.

			aResultWithError := GtSourceCoderEvaluationResultWithRuntimeError new 
				isResignaled: wasErrorAlreadySignaled;
				error: anError.
			
			"let the caller to set source string and source interval"
			anErrorBlock value: aResultWithError.
			
			wasErrorAlreadySignaled 
				ifTrue: [ 
					"Continue the handling of this exception. This will open a debugger 
					if the error is not caught elsewhere."
					anError pass.
					^ nil ]
				ifFalse: [
					wasErrorAlreadySignaled := true.
					
					aResultWithError error: (GtCoderEvaluationUnhandledError new
							exception: anError;
							sourceCoder: self;
							sourceString: aResultWithError sourceString;
							sourceInterval: aResultWithError sourceInterval).
					
					anError resignalAs: aResultWithError error.
					^ nil ].

			"Normally, the process will be terminated during error handling, however if debugger fails to open
			it may not be terminated, so we should return a result with an explicit error "
			^ aResultWithError ].

	^ GtSourceCoderEvaluationResultWithValue new value: aResult
]

{ #category : #'private - actions' }
GtSourceCoder >> evaluationContext [
	<return: #GtSourceCoderEvaluationContext>

	^ GtSourceCoderEvaluationContext new
		requesterObject: self;
		coder: self
]

{ #category : #'private - notifying' }
GtSourceCoder >> notifyEvaluatedWithResult: anEvaluationResult [
	self announce: (GtCoderEvaluationAnnouncement new 
		evaluationResult: anEvaluationResult;
		coder: self)
]

{ #category : #'private - notifying' }
GtSourceCoder >> notifyObjectSpawn: anObject [
	self
		notifyObjectSpawn: anObject
		withDestination: self spawnDestination
]

{ #category : #'private - notifying' }
GtSourceCoder >> notifyObjectSpawn: anObject withDestination: aSpawnDestination [
	self announce: (GtCoderObjectSpawnRequest new 
		object: anObject;
		spawnDestination: aSpawnDestination;
		coder: self)
]

{ #category : #'private - notifying' }
GtSourceCoder >> notifyObjectSpawnFromEvaluationResult: anEvaluationResult [
	
	anEvaluationResult isSuccess
		ifFalse: [ ^ self ].
	
	self
		notifyObjectSpawn: anEvaluationResult value
]

{ #category : #'private - notifying' }
GtSourceCoder >> notifyPrintResult: anEvaluationResult [
	self announce: (GtCoderPrintAnnouncement new 
		evaluationResult: anEvaluationResult;
		coder: self)
]

{ #category : #'private - notifying' }
GtSourceCoder >> notifyShowDebuggerRequest: aDebugSession dueTo: anException sourceString: aSourceString sourceInterval: aSourceInterval [
	self announce: (GtCoderShowDebuggerRequest new
		coder: self;
		debugSession: aDebugSession;
		exception: anException;
		sourceString: aSourceString;
		sourceInterval: aSourceInterval)
]

{ #category : #'private - actions' }
GtSourceCoder >> primitiveEvaluate: aSourceString inContext: aGtSourceCoderEvaluationContext onFailDo: anEvaluationFailBlock [
	^ self subclassResponsibility
]

{ #category : #'api - actions' }
GtSourceCoder >> printItInContext: aGtSourceCoderEvaluationContext [
	^ self
		evaluate: [ :thisCoder | thisCoder currentSourceString ]
		inContext: aGtSourceCoderEvaluationContext
		thenDo: [ :aResult | self notifyPrintResult: aResult ]
]

{ #category : #accessing }
GtSourceCoder >> spawnDestination [
	^ self 
		attributeNamed: #spawnDestination 
		ifAbsent: [ GtPhlowSpawnDesiredDestination defaultDestination ]
]

{ #category : #accessing }
GtSourceCoder >> spawnDestination: aSpawnDestination [
	self attributeNamed: #spawnDestination put: aSpawnDestination
]
