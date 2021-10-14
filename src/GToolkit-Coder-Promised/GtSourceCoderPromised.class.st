Class {
	#name : #GtSourceCoderPromised,
	#superclass : #GtTextualCoderPromised,
	#category : #'GToolkit-Coder-Promised'
}

{ #category : #'api - actions' }
GtSourceCoderPromised >> debug [
	self debugInContext: self evaluationContext
]

{ #category : #'private - actions' }
GtSourceCoderPromised >> debug: aSourceStringOrBlock inContext: aGtSourceCoderEvaluationContext [
	| aSourceString aSourceInterval aCompleteSourceString |

	self critical: [
		aCompleteSourceString := aSourceStringOrBlock isClosure
			ifTrue: [ aSourceStringOrBlock cull: self ]
			ifFalse: [ aSourceStringOrBlock ].
		aSourceString := aGtSourceCoderEvaluationContext sourceInterval computeSourceString: aCompleteSourceString.
		aSourceInterval := aGtSourceCoderEvaluationContext sourceInterval computeSourceInterval: aCompleteSourceString. ].

	aGtSourceCoderEvaluationContext
		sourceString: aCompleteSourceString;
		evaluatedSourceString: aSourceString;
		evaluatedInterval: aSourceInterval.

	self
		primitiveDebug: aSourceString
		inContext: aGtSourceCoderEvaluationContext
		onFailDo: [ self error: 'Failed to debug' ]
]

{ #category : #'api - actions' }
GtSourceCoderPromised >> debugInContext: aGtSourceCoderEvaluationContext [
	self debug: self currentSourceString inContext: aGtSourceCoderEvaluationContext
]

{ #category : #'api - actions' }
GtSourceCoderPromised >> discardChanges [
	"Discard not-accepted changes."

	self isModified
		ifFalse: [ ^ self ].

	self sourceCode resetCollapsedText.
	self sourceCode resetSourceText.

	self sourceChanged
]

{ #category : #'api - actions' }
GtSourceCoderPromised >> doItAll [
	"Evaluate the whole source code in a default evaluation context and return the result.
	See the implementation of #evaluationContext to find the default state"

	^ self doItInContext: self evaluationContext
]

{ #category : #'api - actions' }
GtSourceCoderPromised >> doItAndGo [
	"Evaluate and inspect the whole source code in a default evaluation context and return the result.
	See the implementation of #evaluationContext to find the default state"

	^ self doItAndGoInContext: self evaluationContext
]

{ #category : #'api - actions' }
GtSourceCoderPromised >> doItAndGoInContext: aGtSourceCoderEvaluationContext [
	^ self
		evaluate: [ :thisCoder | thisCoder currentSourceString ]
		inContext: aGtSourceCoderEvaluationContext
		thenDo: [ :anEvaluationResult |
			self notifyEvaluatedWithResult: anEvaluationResult.
			self notifyObjectSpawnFromEvaluationResult: anEvaluationResult ]
]

{ #category : #'api - actions' }
GtSourceCoderPromised >> doItInContext: aGtSourceCoderEvaluationContext [
	^ self
		doItInContext: aGtSourceCoderEvaluationContext
		thenDo: [ :aResult | self notifyEvaluatedWithResult: aResult ]
]

{ #category : #'api - actions' }
GtSourceCoderPromised >> doItInContext: aGtSourceCoderEvaluationContext thenDo: aBlock [
	^ self
		evaluate: [ :thisCoder | thisCoder currentSourceString ]
		inContext: aGtSourceCoderEvaluationContext
		thenDo: aBlock
]

{ #category : #'private - actions' }
GtSourceCoderPromised >> evaluate: aSourceStringOrBlock [
	"Evaluate a given source code and show the print string if needed"

	^ self
		evaluate: aSourceStringOrBlock
		thenDo: [  ]
]

{ #category : #'private - actions' }
GtSourceCoderPromised >> evaluate: aSourceStringOrBlock decorated: aSourceCodeDecorator inContext: aSourceCoderEvaluationContext thenDo: aThenBlock [
	"Evaluate a given source code"
	| aCompleteSourceString aSourceString aSourceInterval aResult aDecoratedSourceString |
	
	"we can not wrap everything in a critical: because if there is an exception while evaluating
	the source code the current running process will be suspended, meaning that the very next evaluation
	will indefinitely wait when trying to enter a critical section."
	self critical: [
		aCompleteSourceString := aSourceStringOrBlock isClosure
			ifTrue: [ aSourceStringOrBlock cull: self ]
			ifFalse: [ aSourceStringOrBlock ].

		aSourceString := aSourceCoderEvaluationContext sourceInterval computeSourceString: aCompleteSourceString.
		aSourceInterval := aSourceCoderEvaluationContext sourceInterval computeSourceInterval: aCompleteSourceString ].

	aDecoratedSourceString := aSourceCodeDecorator value: aSourceString.
	
	aSourceCoderEvaluationContext
		sourceString: aCompleteSourceString;
		evaluatedSourceString: aSourceString;
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
GtSourceCoderPromised >> evaluate: aSourceStringOrBlock inContext: aGtSourceCoderEvaluationContext thenDo: aThenBlock [
	^ self
		evaluate: aSourceStringOrBlock
		decorated: [ :aSourceString | aSourceString ]
		inContext: aGtSourceCoderEvaluationContext
		thenDo: aThenBlock
]

{ #category : #'private - actions' }
GtSourceCoderPromised >> evaluate: aSourceStringOrBlock thenDo: aThenBlock [
	"Evaluate a given source code and show the print string if needed"

	^ self
		evaluate: aSourceStringOrBlock
		inContext: self evaluationContext
		thenDo: aThenBlock
]

{ #category : #'private - actions' }
GtSourceCoderPromised >> evaluateBlock: aBlock onErrorDo: anErrorBlock [
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
GtSourceCoderPromised >> evaluationContext [
	<return: #GtSourceCoderEvaluationContext>

	^ GtSourceCoderEvaluationContext new
		requesterObject: self;
		coder: self
]

{ #category : #testing }
GtSourceCoderPromised >> hasImplicitVariableReferenceTo: aString [
	self implicitVariableReferencesTo: aString do: [ :each | ^ true ].
	^ false
]

{ #category : #'api - ast' }
GtSourceCoderPromised >> implicitVariableReferencesTo: aString do: aBlock [
	"Evaluate aBlock for every ast node that is a variable reference to an implicitly defined variable named aString."

	
]

{ #category : #'private - notifying' }
GtSourceCoderPromised >> notifyEvaluatedWithResult: anEvaluationResult [
	self announce: (GtCoderEvaluationAnnouncement new 
		evaluationResult: anEvaluationResult;
		coder: self)
]

{ #category : #'private - notifying' }
GtSourceCoderPromised >> notifyObjectSpawn: anObject [
	self
		notifyObjectSpawn: anObject
		withDestination: self spawnDestination
]

{ #category : #'private - notifying' }
GtSourceCoderPromised >> notifyObjectSpawn: anObject withDestination: aSpawnDestination [
	self announce: (GtCoderObjectSpawnRequest new 
		object: anObject;
		spawnDestination: aSpawnDestination;
		coder: self)
]

{ #category : #'private - notifying' }
GtSourceCoderPromised >> notifyObjectSpawnFromEvaluationResult: anEvaluationResult [
	
	anEvaluationResult isSuccess
		ifFalse: [ ^ self ].
	
	self
		notifyObjectSpawn: anEvaluationResult value
]

{ #category : #'private - notifying' }
GtSourceCoderPromised >> notifyPrintResult: anEvaluationResult [
	self announce: (GtCoderPrintAnnouncement new 
		evaluationResult: anEvaluationResult;
		coder: self)
]

{ #category : #'private - notifying' }
GtSourceCoderPromised >> notifyShowDebuggerRequest: aDebugSession dueTo: anException sourceString: aSourceString sourceInterval: aSourceInterval [
	(self announcer subscriptionsForClass: GtCoderShowDebuggerRequest) size isZero
		ifTrue: [
			^ Smalltalk tools debugger
				openOn: aDebugSession
				withFullView: true ].

	self announce: (GtCoderShowDebuggerRequest new
		coder: self;
		debugSession: aDebugSession;
		exception: anException;
		sourceString: aSourceString;
		sourceInterval: aSourceInterval)
]

{ #category : #'private - actions' }
GtSourceCoderPromised >> primitiveDebug: aSourceString inContext: aGtSourceCoderEvaluationContext onFailDo: anEvaluationFailBlock [
	^ self subclassResponsibility
]

{ #category : #'private - actions' }
GtSourceCoderPromised >> primitiveEvaluate: aSourceString inContext: aGtSourceCoderEvaluationContext onFailDo: anEvaluationFailBlock [
	^ self subclassResponsibility
]

{ #category : #'api - actions' }
GtSourceCoderPromised >> printItInContext: aGtSourceCoderEvaluationContext [
	^ self
		evaluate: [ :thisCoder | thisCoder currentSourceString ]
		inContext: aGtSourceCoderEvaluationContext
		thenDo: [ :aResult | self notifyPrintResult: aResult ]
]

{ #category : #'api - ast' }
GtSourceCoderPromised >> renameImplicitTemporary: oldName to: newName [
	| source |
	source := SmaCCString on: self currentSourceString.
	self
		implicitVariableReferencesTo: oldName
		do:
			[ :node | 
			source
				replaceFrom: node startPosition
				to: node stopPosition
				with: newName ].
	self currentSourceString: source asString
]

{ #category : #accessing }
GtSourceCoderPromised >> spawnDestination [
	^ self 
		attributeNamed: #spawnDestination 
		ifAbsent: [ GtPhlowSpawnDesiredDestination defaultDestination ]
]

{ #category : #accessing }
GtSourceCoderPromised >> spawnDestination: aSpawnDestination [
	self attributeNamed: #spawnDestination put: aSpawnDestination
]
