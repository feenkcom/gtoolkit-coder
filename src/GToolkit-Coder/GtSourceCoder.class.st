"
# Source coder
Is a language agnostic model of a source coder.
My subclasses extend my by adding support for a specific language.

### Code execution
To add support for code execution the subclasses must implement
- {{gtMethod:GtSourceCoder>>#primitiveEvaluate:inContext:onFailDo:}}.

### Code debugging
To add support for code debugging the subclasses must implement
- {{gtMethod:GtSourceCoder>>#primitiveDebug:inContext:onFailDo:}}
"
Class {
	#name : #GtSourceCoder,
	#superclass : #GtTextualCoder,
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #'api - actions' }
GtSourceCoder >> debug [
	self debugInContext: self evaluationContext
]

{ #category : #'private - actions' }
GtSourceCoder >> debug: aSourceStringOrBlock inContext: aGtSourceCoderEvaluationContext [
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
GtSourceCoder >> debugInContext: aGtSourceCoderEvaluationContext [
	self debug: self currentSourceString inContext: aGtSourceCoderEvaluationContext
]

{ #category : #'api - actions' }
GtSourceCoder >> discardChanges [
	"Discard not-accepted changes."

	self isModified
		ifFalse: [ ^ self ].

	self sourceCode resetSourceText.

	self sourceChangedTo: nil
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
			self
				notifyObjectSpawnFromEvaluationResult: anEvaluationResult
				requesterObject: aGtSourceCoderEvaluationContext requesterObject ]
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
							evaluatedCode: aResultWithError evaluatedCode;
							sourceString: aResultWithError sourceString;
							sourceInterval: aResultWithError sourceInterval;
							requesterObject: aResultWithError requesterObject).
					
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

	^ self newEvaluationContext
		requesterObject: (GtSourceCoderRequester new coder: self);
		coder: self
]

{ #category : #testing }
GtSourceCoder >> hasImplicitVariableReferenceTo: aString [
	self implicitVariableReferencesTo: aString do: [ :each | ^ true ].
	^ false
]

{ #category : #accessing }
GtSourceCoder >> implicitVariableNames [
	^ #()
]

{ #category : #'api - ast' }
GtSourceCoder >> implicitVariableReferencesTo: aString do: aBlock [
	"Evaluate aBlock for every ast node that is a variable reference to an implicitly defined variable named aString."

	
]

{ #category : #'private - actions' }
GtSourceCoder >> newEvaluationContext [
	^ GtSourceCoderEvaluationContext new
]

{ #category : #'private - ast' }
GtSourceCoder >> nodeAt: anIndex [
	^ self
		nodeAt: anIndex
		ifFound: [ :aNode | 
			aNode isSequence
				ifTrue: [ aNode statements
						detect: [ :eachNode | eachNode intersectsInterval: (anIndex to: anIndex) ] ]
				ifFalse: [ aNode ] ]
		ifNone: [ nil ]
]

{ #category : #'private - ast' }
GtSourceCoder >> nodeAt: aTextPosition ifFound: aFoundBlock ifNone: aNoneBlock [
	<return: #Object>
	[
		| theAST innerNode |
		theAST := self astSync.
		theAST
			withAllNodesDo: [ :node | 
				(aTextPosition between: node startPosition - 1 and: node stopPosition)
					ifTrue: [ innerNode := node ] ].
		
		^ innerNode ifNil: aNoneBlock ifNotNil: aFoundBlock ]
			on: Error
			do: [ :ex | ex return ].

	^ aNoneBlock value
]

{ #category : #accessing }
GtSourceCoder >> nodeFrom: aCoderViewModel [
	| allSelections allCursors |
	allSelections := aCoderViewModel selection allSelections.
	allCursors := aCoderViewModel cursors allCursors.
 
	^ allSelections size = 1
		ifTrue: [ self nodeWithin: (allSelections first from + 1
			to: allSelections first to)  ]
		ifFalse: [ allCursors size = 1 ifTrue: [ 
			self nodeAt: allCursors first position ] ]
]

{ #category : #accessing }
GtSourceCoder >> nodeWithin: anInterval [
	^ self
		nodeWithin: anInterval
		ifFound: [ :aNode | 
			aNode isSequence
				ifTrue: [ aNode statements
						detect: [ :eachNode | eachNode intersectsInterval: anInterval ] ]
				ifFalse: [ aNode ] ]
		ifNone: [  ]
]

{ #category : #'private - ast' }
GtSourceCoder >> nodeWithin: anInterval ifFound: aFoundBlock ifNone: aNoneBlock [
	<return: #Object>

	[
		| theAST |
		theAST := self astSync.
		^ theAST
			bestNodeFor: anInterval
			ifFound: aFoundBlock
			ifNone: aNoneBlock ]
				on: Error
				do: [ :ex | ex return ].

	^ aNoneBlock value
]

{ #category : #'private - notifying' }
GtSourceCoder >> notifyEvaluatedWithResult: anEvaluationResult [
	self announce: (GtCoderEvaluationAnnouncement new 
		evaluationResult: anEvaluationResult;
		coder: self)
]

{ #category : #'private - notifying' }
GtSourceCoder >> notifyObjectSpawn: anObject requesterObject: aRequester [
	self
		notifyObjectSpawn: anObject
		withDestination: self spawnDestination
		requesterObject: aRequester
]

{ #category : #'private - notifying' }
GtSourceCoder >> notifyObjectSpawn: anObject withDestination: aSpawnDestination requesterObject: aRequester [
	self announce: (GtCoderObjectSpawnRequest new 
		object: anObject;
		spawnDestination: aSpawnDestination;
		coder: self;
		requesterObject: aRequester)
]

{ #category : #'private - notifying' }
GtSourceCoder >> notifyObjectSpawnFromEvaluationResult: anEvaluationResult requesterObject: aRequester [
	anEvaluationResult isSuccess ifFalse: [ ^ self ].

	self notifyObjectSpawn: anEvaluationResult value requesterObject: aRequester
]

{ #category : #'private - notifying' }
GtSourceCoder >> notifyParseError: aString at: anInteger requesterObject: aRequester [
	self announce: (GtCoderParseError new
		coder: self;
		errorMessage: aString;
		location: anInteger;
		requesterObject: aRequester)
]

{ #category : #'private - notifying' }
GtSourceCoder >> notifyParseError: aSemanticWarning requesterObject: aRequester [
	self
		announce: (GtCoderParseError new
				coder: self;
				exception: aSemanticWarning;
				errorMessage: aSemanticWarning messageText;
				location: aSemanticWarning location;
				requesterObject: aRequester)
]

{ #category : #'private - notifying' }
GtSourceCoder >> notifyPrintResult: anEvaluationResult [
	self announce: (GtCoderPrintAnnouncement new 
		evaluationResult: anEvaluationResult;
		coder: self)
]

{ #category : #'private - notifying' }
GtSourceCoder >> notifyToolSpawn: aTool withDestination: aSpawnDestination requesterObject: aRequester [
	self announce: (GtCoderToolSpawnRequest new 
		tool: aTool;
		spawnDestination: aSpawnDestination;
		requesterObject: aRequester;
		coder: self)
]

{ #category : #'private - actions' }
GtSourceCoder >> primitiveDebug: aSourceString inContext: aGtSourceCoderEvaluationContext onFailDo: anEvaluationFailBlock [
	^ self subclassResponsibility
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

{ #category : #'api - ast' }
GtSourceCoder >> renameImplicitTemporary: oldName to: newName [
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
GtSourceCoder >> spawnDestination [
	^ self 
		attributeNamed: #spawnDestination 
		ifAbsent: [ GtPhlowSpawnDesiredDestination defaultDestination ]
]

{ #category : #accessing }
GtSourceCoder >> spawnDestination: aSpawnDestination [
	self attributeNamed: #spawnDestination put: aSpawnDestination
]

{ #category : #'private - actions' }
GtSourceCoder >> validateSyntax [
	<return: #Boolean>
	^ self validateSyntaxInContext: self evaluationContext
]

{ #category : #'private - actions' }
GtSourceCoder >> validateSyntaxInContext: aGtPharoSourceCoderEvaluationContext [
	<return: #Boolean>
	[ self computeCoderAst ]
		on: SmaCCParserError
		do: [ :ex | 
			self
				notifyParseError: ex messageText
				at: ex tag position
				requesterObject: aGtPharoSourceCoderEvaluationContext requesterObject.
			^ false ].
	^ true
]
