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
GtSourceCoder >> doIt: aSourceIntervalOrBlock [
	"Evaluate a piece of source code within an interval and return a result.
	I am also able to evaluate an empty or only consisting of whitespace
	source code in which case the result is nil"
	<return: #Object>

	^ self
		doIt: aSourceIntervalOrBlock
		thenDo: [ :aResult | self notifyEvaluatedWithResult: aResult ]
]

{ #category : #'api - actions' }
GtSourceCoder >> doIt: aSourceIntervalOrBlock thenDo: aBlock [
	"Evaluate a piece of source code within an interval and return a result.
	I am also able to evaluate an empty or only consisting of whitespace
	source code in which case the result is nil"
	<return: #Object>

	^ self
		evaluateInterval: aSourceIntervalOrBlock
		requestedBy: self
		thenDo: aBlock
]

{ #category : #'api - actions' }
GtSourceCoder >> doItAll [
	^ self doItAllRequestedBy: self
]

{ #category : #'api - actions' }
GtSourceCoder >> doItAllRequestedBy: aRequesterObject [
	^ self
		doItAllThenDo: [ :aResult | self notifyEvaluatedWithResult: aResult ]
		requestedBy: aRequesterObject
]

{ #category : #'api - actions' }
GtSourceCoder >> doItAllThenDo: aBlock [
	^ self
		evaluate: [ :thisCoder | thisCoder currentSourceString ]
		thenDo: aBlock
]

{ #category : #'api - actions' }
GtSourceCoder >> doItAllThenDo: aBlock requestedBy: aRequesterObject [
	^ self
		evaluate: [ :thisCoder | thisCoder currentSourceString ]
		requestedBy: aRequesterObject
		thenDo: aBlock
]

{ #category : #'api - actions' }
GtSourceCoder >> doItAndGo: aSourceIntervalOrBlock [

	^ self
		evaluateInterval: aSourceIntervalOrBlock
		requestedBy: self
		thenDo: [ :anEvaluationResult |
			self notifyEvaluatedWithResult: anEvaluationResult.
			self notifyObjectSpawnFromEvaluationResult: anEvaluationResult ]
]

{ #category : #'api - actions' }
GtSourceCoder >> doItAndGoAll [
	^ self
		evaluate: [ :thisCoder | thisCoder currentSourceString ]
		thenDo: [ :anEvaluationResult |
			self notifyEvaluatedWithResult: anEvaluationResult.
			self notifyObjectSpawnFromEvaluationResult: anEvaluationResult ]
]

{ #category : #'private - actions' }
GtSourceCoder >> evaluate: aSourceStringOrBlock [
	"Evaluate a given source code and show the print string if needed"

	^ self
		evaluate: aSourceStringOrBlock
		thenDo: [  ]
]

{ #category : #'private - actions' }
GtSourceCoder >> evaluate: aSourceStringOrBlock decorated: aSourceCodeDecorator requestedBy: aRequesterObject thenDo: aThenBlock [
	"Evaluate a given source code"
	| aSourceString aRequester aResult aDecoratedSourceString |
	
	"we can not wrap everything in a critical: because if there is an exception while evaluating
	the source code the current running process will be suspended, meaning that the very next evaluation
	will indefinitely wait when trying to enter a critical section."
	self critical: [
		aSourceString := aSourceStringOrBlock isClosure
			ifTrue: [ aSourceStringOrBlock cull: self ]
			ifFalse: [ aSourceStringOrBlock ].
		aRequester := self evaluationRequester requesterObject: aRequesterObject ].

	aDecoratedSourceString := aSourceCodeDecorator value: aSourceString.

	aResult := self evaluateBlock: [ 
		self
			primitiveEvaluate: aDecoratedSourceString
			requester: aRequester
			onFailDo: [
				| aResultWithSyntaxError |
				aResultWithSyntaxError := GtSourceCoderEvaluationResultWithSyntaxError new
					sourceCoder: self;
					requesterObject: aRequesterObject;
					sourceString: aSourceString;
					sourceInterval: (1 to: aSourceString size).
				aThenBlock cull: aResultWithSyntaxError.
				^ aResultWithSyntaxError ] ]
		onErrorDo: [ :aResultWithError |
			aResultWithError
				requesterObject: aRequesterObject;
				sourceString: aSourceString;
				sourceInterval: (1 to: aSourceString size) ].

	aResult
		requesterObject: aRequesterObject;
		sourceString: aSourceString;
		sourceInterval: (1 to: aSourceString size).

	aThenBlock cull: aResult.
	^ aResult
]

{ #category : #'private - actions' }
GtSourceCoder >> evaluate: aSourceStringOrBlock requestedBy: aRequesterObject thenDo: aThenBlock [
	"Evaluate a given source code and show the print string if needed"

	^ self
		evaluate: aSourceStringOrBlock
		decorated: [ :aSource | aSource ]
		requestedBy: aRequesterObject
		thenDo: aThenBlock
]

{ #category : #'private - actions' }
GtSourceCoder >> evaluate: aSourceStringOrBlock thenDo: aThenBlock [
	"Evaluate a given source code and show the print string if needed"

	^ self
		evaluate: aSourceStringOrBlock
		requestedBy: self
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
			
			aResultWithError := GtSourceCoderEvaluationResultWithRuntimeError new 
				sourceCoder: self;
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

	^ GtSourceCoderEvaluationResultWithValue new sourceCoder: self; value: aResult
]

{ #category : #'private - actions' }
GtSourceCoder >> evaluateInterval: aSourceIntervalOrBlock [
	^ self
		evaluateInterval: aSourceIntervalOrBlock
		requestedBy: self
		thenDo: [ ]
]

{ #category : #'private - actions' }
GtSourceCoder >> evaluateInterval: aSourceIntervalOrBlock requestedBy: aRequesterObject thenDo: aThenBlock [
	"Evaluate a part of the source code within the interval that is specified by aSourceIntervalOrBlock
	which can directly be an Interval or a block that when evaluated returns an interval"
	| aSourceText aSourceInterval aSourceString aRequester anEvaluationResult |
	
	"we can not wrap everything in a critical: because if there is an exception while evaluating
	the source code the current running process will be suspended, meaning that the very next evaluation
	will indefinitely wait when trying to enter a critical section."
	self critical: [
		aSourceText := self sourceText.
		aSourceInterval := aSourceIntervalOrBlock isClosure
			ifTrue: [ aSourceIntervalOrBlock cull: aSourceText]
			ifFalse: [ aSourceIntervalOrBlock ].
		aSourceString := (aSourceText copyFrom: aSourceInterval first to: aSourceInterval last) asString.
		aRequester := self evaluationRequesterWithInterval
			interval: aSourceInterval;
			source: aSourceString;
			requesterObject: aRequesterObject ].

	anEvaluationResult := aSourceString
			ifNotEmpty: [
				| aResult |
				aResult := self evaluateBlock: [
					self
						primitiveEvaluate: aSourceString
						requester: aRequester
						onFailDo: [
							| aResultWithSyntaxError |
							aResultWithSyntaxError := GtSourceCoderEvaluationResultWithSyntaxError new
								sourceCoder: self;
								sourceString: aSourceString;
								sourceInterval: aSourceInterval.
							self notifyEvaluatedWithResult: aResultWithSyntaxError.
							aThenBlock cull: aResultWithSyntaxError.
							^ aResultWithSyntaxError ] ]
					onErrorDo: [ :aResultWithError |
						aResultWithError
							sourceString: aSourceString;
							sourceInterval: aSourceInterval ].

				aResult
					sourceString: aSourceString;
					sourceInterval: aSourceInterval.

				aResult ]
			ifEmpty: [
				GtSourceCoderEvaluationResultWithSyntaxError new
					sourceCoder: self;
					sourceString: '';
					sourceInterval: (1 to: 0) ].

	self notifyEvaluatedWithResult: anEvaluationResult.
	aThenBlock cull: anEvaluationResult.
	^ anEvaluationResult
]

{ #category : #'private - actions' }
GtSourceCoder >> evaluationRequester [
	^ GtSourceCoderEvaluationRequester new coder: self
]

{ #category : #'private - actions' }
GtSourceCoder >> evaluationRequesterWithInterval [
	^ GtSourceCoderIntervalEvaluationRequester new coder: self
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

{ #category : #'private - actions' }
GtSourceCoder >> primitiveEvaluate: aSourceString requester: aRequester onFailDo: anEvaluationFailBlock [
	^ self subclassResponsibility
]

{ #category : #'api - actions' }
GtSourceCoder >> printItAll [
	^ self
		evaluate: [ :thisCoder | thisCoder currentSourceString ]
		thenDo: [ :aResult | self notifyPrintResult: aResult ]
]

{ #category : #'api - actions' }
GtSourceCoder >> printItWithin: aSourceIntervalBlock [
	"Evaluate a piece of source code within an interval returned by aSourceIntervalBlock and return a result.
	I am also able to evaluate an empty or only consisting of whitespace
	source code in which case the result is nil"
	<return: #Object>

	^ self
		evaluateInterval: aSourceIntervalBlock
		requestedBy: self
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
