Class {
	#name : #GtPharoMethodCoderExamples,
	#superclass : #Object,
	#traits : 'TGtPharoCoderExamplesWithDummies',
	#classTraits : 'TGtPharoCoderExamplesWithDummies classTrait',
	#category : #'GToolkit-Coder-Pharo-Examples-Coders'
}

{ #category : #'sample methods' }
GtPharoMethodCoderExamples >> ? anObject [
	"Test binary method"
]

{ #category : #'sample methods' }
GtPharoMethodCoderExamples >> a [
	<gtExample>
	^ 42
]

{ #category : #'sample methods' }
GtPharoMethodCoderExamples >> a: arg1 a: arg2 a: arg3 a: arg4 [
	"test method for highlighting implementors"
]

{ #category : #'sample methods' }
GtPharoMethodCoderExamples >> b [
	<gtExample>
	^ self a * self notAnExample
]

{ #category : #'examples - instance creation' }
GtPharoMethodCoderExamples >> coderOnClassUnaryMethodThatCreatesPoint [
	<gtExample>
	| aCoder |
	
	aCoder := self forUnaryClassMethod.
	aCoder appendString: '
	| aPoint |
	
	aPoint := 196@400.
	^ aPoint x sqrt @ aPoint y sqrt'.
	
	^ aCoder
]

{ #category : #'examples - compile' }
GtPharoMethodCoderExamples >> compileMethodWithCoderModifiedWhenSubscribedToSystem [
	<gtExample>
	| aMethodCoder wasSuccessful anEventsRecoder anOldMethod aNewMethod |
	
	anEventsRecoder := self eventsRecorder.
	
	aMethodCoder := self forUnaryInstanceMethod.
	anOldMethod := (aMethodCoder attributeNamed: #dummyMethod) realMethod.
	
	aMethodCoder sourceText append: '"modified"' asRopedText.
	aMethodCoder subscribeToSystem.
	
	self assert: aMethodCoder isModified.
	self assert: aMethodCoder currentSourceString equals: anOldMethod sourceCode, '"modified"'.
	
	aMethodCoder weak
		when: GtCoderClassRemoved send: #record: to: anEventsRecoder;
		when: GtCoderMethodAdded send: #record: to: anEventsRecoder;
		when: GtCoderMethodModified send: #record: to: anEventsRecoder;
		when: GtCoderMethodRemoved send: #record: to: anEventsRecoder.

	wasSuccessful := [ aMethodCoder compile ]
		ensure: [ aMethodCoder unsubscribeFromSystem ].
	
	self assert: wasSuccessful.
	aNewMethod := (aMethodCoder attributeNamed: #dummyMethod) realClass >> anOldMethod selector.

	self assert: aMethodCoder behavior equals: (aMethodCoder attributeNamed: #dummyMethod) realClass.
	self assert: aMethodCoder selector equals: aNewMethod selector.
	self assert: aMethodCoder selector equals: anOldMethod selector.
	self assert: aMethodCoder compiledMethod equals: aNewMethod.
	self assert: aMethodCoder protocol equals: aNewMethod protocol.
	self assert: aMethodCoder existsInTheSystem.
	self assert: aMethodCoder isModified not.

	self assert: aMethodCoder currentSourceString equals: anOldMethod sourceCode, '"modified"'.
	self assert: aMethodCoder sourceCode class equals: GtCoderCompiledMethodSourceCode.
	self assert: aMethodCoder sourceCode compiledMethod == aNewMethod.
	self assert: aMethodCoder sourceCode sourceString equals: anOldMethod sourceCode, '"modified"'.
	self assert: aMethodCoder sourceCode buildSourceText asString equals: anOldMethod sourceCode, '"modified"'.

	self assert: anEventsRecoder numberOfEvents equals: 1.
	self assert: anEventsRecoder first class equals: GtCoderMethodModified.
	self assert: anEventsRecoder first coder equals: aMethodCoder.
	
	^ aMethodCoder
]

{ #category : #'examples - compile' }
GtPharoMethodCoderExamples >> compileMethodWithCoderWhenSubscribedToSystem [
	<gtExample>
	| aMethodCoder wasSuccessful anEventsRecoder anOldMethod aNewMethod |
	
	anEventsRecoder := self eventsRecorder.
	
	aMethodCoder := self forUnaryInstanceMethod.
	anOldMethod := (aMethodCoder attributeNamed: #dummyMethod) realMethod.
	
	aMethodCoder subscribeToSystem.
	
	self assert: aMethodCoder isModified not.
	self assert: aMethodCoder currentSourceString equals: anOldMethod sourceCode.
	
	aMethodCoder weak
		when: GtCoderClassRemoved send: #record: to: anEventsRecoder;
		when: GtCoderMethodAdded send: #record: to: anEventsRecoder;
		when: GtCoderMethodModified send: #record: to: anEventsRecoder;
		when: GtCoderMethodRemoved send: #record: to: anEventsRecoder.

	wasSuccessful := [ aMethodCoder compile ]
		ensure: [ aMethodCoder unsubscribeFromSystem ].
	
	self assert: wasSuccessful.
	aNewMethod := (aMethodCoder attributeNamed: #dummyMethod) realClass >> anOldMethod selector.

	self assert: aMethodCoder behavior equals: (aMethodCoder attributeNamed: #dummyMethod) realClass.
	self assert: aMethodCoder selector equals: aNewMethod selector.
	self assert: aMethodCoder selector equals: anOldMethod selector.
	self assert: aMethodCoder compiledMethod equals: aNewMethod.
	self assert: aMethodCoder protocol equals: aNewMethod protocol.
	self assert: aMethodCoder existsInTheSystem.
	self assert: aMethodCoder isModified not.

	self assert: aMethodCoder currentSourceString equals: anOldMethod sourceCode.
	self assert: aMethodCoder sourceCode class equals: GtCoderCompiledMethodSourceCode.
	self assert: aMethodCoder sourceCode compiledMethod == aNewMethod.
	self assert: aMethodCoder sourceCode sourceString equals: anOldMethod sourceCode.
	self assert: aMethodCoder sourceCode buildSourceText asString equals: anOldMethod sourceCode.

	self assert: anEventsRecoder numberOfEvents equals: 1.
	self assert: anEventsRecoder first class equals: GtCoderMethodModified.
	self assert: anEventsRecoder first coder equals: aMethodCoder.
	
	^ aMethodCoder
]

{ #category : #'examples - compile' }
GtPharoMethodCoderExamples >> compileMethodWithTempAndBlockArgsConflictWhenSubscribedToSystem [
	<gtExample>
	| aMethodCoder wasSuccessful anEventsRecoder |
	
	anEventsRecoder := self eventsRecorder.

	aMethodCoder := self forNewMethod.
	aMethodCoder currentSourceString: self methodSourceWithTempAndBlockArgsConflict.
	aMethodCoder subscribeToSystem.
	
	self assert: aMethodCoder isModified.
	
	aMethodCoder
		when: GtCoderAnnouncement send: #record: to: anEventsRecoder.

	wasSuccessful := [ aMethodCoder compile ]
		ensure: [ aMethodCoder unsubscribeFromSystem ].
	
	self assert: wasSuccessful not.

	self assert: anEventsRecoder numberOfEvents equals: 2.
	self assert: anEventsRecoder first class equals: GtCoderAstChanged.
	self assert: anEventsRecoder first coder equals: aMethodCoder.
	self assert: anEventsRecoder second class equals: GtCoderParseError.
	self assert: anEventsRecoder second coder equals: aMethodCoder.
	self assert: anEventsRecoder second errorMessage equals: 'Temp shadows: each'.

	^ aMethodCoder
]

{ #category : #'examples - compile' }
GtPharoMethodCoderExamples >> compileMethodWithoutCoderModifiedWhenSubscribedToSystem [
	<gtExample>
	| aMethodCoder aCompiledSelector anEventsRecoder anOldMethod aNewMethod |
	
	anEventsRecoder := self eventsRecorder.
	
	aMethodCoder := self forUnaryInstanceMethod.
	anOldMethod := (aMethodCoder attributeNamed: #dummyMethod) realMethod.
	
	aMethodCoder sourceText append: '"modified"' asRopedText.
	aMethodCoder subscribeToSystem.
	
	self assert: aMethodCoder isModified.
	self assert: aMethodCoder currentSourceString equals: anOldMethod sourceCode, '"modified"'.
	
	aMethodCoder weak
		when: GtCoderClassRemoved send: #record: to: anEventsRecoder;
		when: GtCoderMethodAdded send: #record: to: anEventsRecoder;
		when: GtCoderMethodModified send: #record: to: anEventsRecoder;
		when: GtCoderMethodRemoved send: #record: to: anEventsRecoder.

	aCompiledSelector := [
		GtPharoCodeModifier
			compileMethodSource: anOldMethod sourceCode, '"new method"'
			in: anOldMethod methodClass
			protocol: anOldMethod protocol ]
		ensure: [ aMethodCoder unsubscribeFromSystem ].
	
	self assert: aCompiledSelector equals: anOldMethod selector.
	aNewMethod := (aMethodCoder attributeNamed: #dummyMethod) realClass >> aCompiledSelector.

	self assert: aMethodCoder behavior equals: (aMethodCoder attributeNamed: #dummyMethod) realClass.
	self assert: aMethodCoder selector equals: aNewMethod selector.
	self assert: aMethodCoder compiledMethod equals: aNewMethod.
	self assert: aMethodCoder protocol equals: aNewMethod protocol.
	self assert: aMethodCoder existsInTheSystem.
	self assert: aMethodCoder isModified.

	self assert: aMethodCoder currentSourceString equals: anOldMethod sourceCode, '"modified"'.
	self assert: aMethodCoder sourceCode class equals: GtCoderCompiledMethodSourceCode.
	self assert: aMethodCoder sourceCode compiledMethod == aNewMethod.
	self assert: aMethodCoder sourceCode sourceString equals: anOldMethod sourceCode, '"modified"'.
	self assert: aMethodCoder sourceCode buildSourceText asString equals: anOldMethod sourceCode, '"new method"'.

	self assert: anEventsRecoder numberOfEvents equals: 1.
	self assert: anEventsRecoder first class equals: GtCoderMethodModified.
	self assert: anEventsRecoder first coder equals: aMethodCoder.
	
	^ aMethodCoder
]

{ #category : #'examples - compile' }
GtPharoMethodCoderExamples >> compileMethodWithoutCoderNotModifiedWhenSubscribedToSystem [
	<gtExample>
	| aMethodCoder aCompiledSelector anEventsRecoder anOldMethod aNewMethod |
	
	anEventsRecoder := self eventsRecorder.
	
	aMethodCoder := self forUnaryInstanceMethod.
	aMethodCoder subscribeToSystem.
	
	self assert: aMethodCoder isModified not.
	
	aMethodCoder weak
		when: GtCoderClassRemoved send: #record: to: anEventsRecoder;
		when: GtCoderMethodAdded send: #record: to: anEventsRecoder;
		when: GtCoderMethodModified send: #record: to: anEventsRecoder;
		when: GtCoderMethodRemoved send: #record: to: anEventsRecoder.

	anOldMethod := (aMethodCoder attributeNamed: #dummyMethod) realMethod.

	aCompiledSelector := [
		GtPharoCodeModifier
			compileMethodSource: anOldMethod sourceCode, '"new method"'
			in: anOldMethod methodClass
			protocol: anOldMethod protocol ]
		ensure: [ aMethodCoder unsubscribeFromSystem ].
	
	self assert: aCompiledSelector equals: anOldMethod selector.
	aNewMethod := (aMethodCoder attributeNamed: #dummyMethod) realClass >> aCompiledSelector.

	self assert: aMethodCoder behavior equals: (aMethodCoder attributeNamed: #dummyMethod) realClass.
	self assert: aMethodCoder selector equals: aNewMethod selector.
	self assert: aMethodCoder compiledMethod equals: aNewMethod.
	self assert: aMethodCoder protocol equals: aNewMethod protocol.
	self assert: aMethodCoder existsInTheSystem.
	self assert: aMethodCoder isModified not.

	self assert: aMethodCoder currentSourceString equals: anOldMethod sourceCode, '"new method"'.
	self assert: aMethodCoder sourceCode class equals: GtCoderCompiledMethodSourceCode.
	self assert: aMethodCoder sourceCode compiledMethod == aNewMethod.
	self assert: aMethodCoder sourceCode sourceString equals: anOldMethod sourceCode, '"new method"'.
	self assert: aMethodCoder sourceCode buildSourceText asString equals: anOldMethod sourceCode, '"new method"'.

	self assert: anEventsRecoder numberOfEvents equals: 1.
	self assert: anEventsRecoder first class equals: GtCoderMethodModified.
	self assert: anEventsRecoder first coder equals: aMethodCoder.
	
	^ aMethodCoder
]

{ #category : #'examples - compile' }
GtPharoMethodCoderExamples >> compileModifiedNewMethodWithCoderWhenSubscribedToSystem [
	<gtExample>
	| aMethodCoder wasSuccessful anEventsRecoder aNewMethodSelector aNewMethod |
	
	anEventsRecoder := self eventsRecorder.
	
	aMethodCoder := self modifyNewMethod.
	
	aMethodCoder subscribeToSystem.
	
	self assert: aMethodCoder isModified.
	aNewMethodSelector := (aMethodCoder attributeNamed: #dummyMethod) selector.
	
	aMethodCoder weak
		when: GtCoderClassRemoved send: #record: to: anEventsRecoder;
		when: GtCoderMethodAdded send: #record: to: anEventsRecoder;
		when: GtCoderMethodModified send: #record: to: anEventsRecoder;
		when: GtCoderMethodRemoved send: #record: to: anEventsRecoder.

	wasSuccessful := [ aMethodCoder compile ]
		ensure: [ aMethodCoder unsubscribeFromSystem ].

	self assert: wasSuccessful.
	aNewMethod := (aMethodCoder attributeNamed: #dummyMethod) realClass >> aNewMethodSelector.

	self assert: aMethodCoder behavior equals: (aMethodCoder attributeNamed: #dummyMethod) realClass.
	self assert: aMethodCoder selector equals: aNewMethod selector.
	self assert: aMethodCoder selector equals: aNewMethodSelector.
	self assert: aMethodCoder compiledMethod equals: aNewMethod.
	self assert: aMethodCoder protocol equals: aNewMethod protocol.
	self assert: aMethodCoder existsInTheSystem.
	self assert: aMethodCoder isModified not.

	self assert: aMethodCoder currentSourceString equals: aNewMethodSelector.
	self assert: aMethodCoder sourceCode class equals: GtCoderCompiledMethodSourceCode.
	self assert: aMethodCoder sourceCode compiledMethod == aNewMethod.
	self assert: aMethodCoder sourceCode sourceString equals: aNewMethodSelector.
	self assert: aMethodCoder sourceCode buildSourceText asString equals: aNewMethodSelector.

	self assert: anEventsRecoder numberOfEvents equals: 1.
	self assert: anEventsRecoder first class equals: GtCoderMethodAdded.
	self assert: anEventsRecoder first coder equals: aMethodCoder.
	
	^ aMethodCoder
]

{ #category : #'examples - compile' }
GtPharoMethodCoderExamples >> compileRemovedMethodWithCoderWhenSubscribedToSystem [
	<gtExample>
	| aMethodCoder aCompileChange aCompilationResult anEventsRecoder |
	
	anEventsRecoder := self eventsRecorder.
	
	aMethodCoder := self removeMethodWithCoderWhenSubscribedToSystem.
	aMethodCoder subscribeToSystem.

	aCompileChange := aMethodCoder createCompileMethodChange.
	self assert: aCompileChange equals: nil.

	aMethodCoder weak
		when: GtCoderClassRemoved send: #record: to: anEventsRecoder;
		when: GtCoderMethodAdded send: #record: to: anEventsRecoder;
		when: GtCoderMethodRemoved send: #record: to: anEventsRecoder.

	aCompilationResult := [ aMethodCoder compile ] ensure: [
		aMethodCoder unsubscribeFromSystem ].
	
	self assert: aCompilationResult not.
	
	self assert: aMethodCoder behavior equals: UndefinedObject.
	self assert: aMethodCoder selector equals: nil.
	self assert: aMethodCoder protocol equals: nil.
	self assert: aMethodCoder compiledMethod equals: nil.
	self assert: aMethodCoder existsInTheSystem not.

	self assert: anEventsRecoder numberOfEvents equals: 0.
	
	^ aMethodCoder
]

{ #category : #'examples - compile' }
GtPharoMethodCoderExamples >> compileRemovedMethodWithoutCoderWhenSubscribedToSystem [
	<gtExample>
	| aMethodCoder aCompileChange aCompilationResult anEventsRecoder |
	
	anEventsRecoder := self eventsRecorder.
	
	aMethodCoder := self removeMethodWithoutCoderWhenSubscribedToSystem.
	aMethodCoder subscribeToSystem.
	
	aCompileChange := aMethodCoder createCompileMethodChange.
	self assert: aCompileChange changeClass equals: (aMethodCoder attributeNamed: #dummyMethod) realClass.
	self assert: aCompileChange selector equals: (aMethodCoder attributeNamed: #dummyMethod) selector.
	self assert: aCompileChange protocol equals: (aMethodCoder attributeNamed: #dummyMethod) protocol.
	self assert: aCompileChange isMeta not.
	
	aMethodCoder weak
		when: GtCoderClassRemoved send: #record: to: anEventsRecoder;
		when: GtCoderMethodAdded send: #record: to: anEventsRecoder;
		when: GtCoderMethodRemoved send: #record: to: anEventsRecoder.

	aCompilationResult := [ aMethodCoder compile ]
		ensure: [ aMethodCoder unsubscribeFromSystem ].
	
	self assert: aCompilationResult.

	self assert: aMethodCoder behavior equals: (aMethodCoder attributeNamed: #dummyMethod) realClass.
	self assert: aMethodCoder selector equals: (aMethodCoder attributeNamed: #dummyMethod) selector.
	self assert: aMethodCoder compiledMethod equals: (aMethodCoder attributeNamed: #dummyMethod) realMethod.
	self assert: aMethodCoder protocol equals: (aMethodCoder attributeNamed: #dummyMethod) protocol.
	self assert: aMethodCoder existsInTheSystem.

	self assert: anEventsRecoder numberOfEvents equals: 1.
	self assert: anEventsRecoder first class equals: GtCoderMethodAdded.
	self assert: anEventsRecoder first coder equals: aMethodCoder.
	
	^ aMethodCoder
]

{ #category : #'examples - debug' }
GtPharoMethodCoderExamples >> debugClassUnaryMethodAll [
	<gtExample>
	| aCoder aCoderViewModel aDummyDebugger |
	
	aCoder := self coderOnClassUnaryMethodThatCreatesPoint.
	self assert: aCoder isModified.

	aCoderViewModel := aCoder asCoderViewModel.

	aDummyDebugger := GtPharoDummyDebugger useDuring: [ aCoderViewModel debug ].

	"debugging does not save the method"
	self assert: aCoder isModified.

	self assert: aDummyDebugger sourceCode equals: aCoder currentSourceString.
	self assert: aDummyDebugger method selector equals: aCoder selector.
	self assert: (aDummyDebugger method methodClass inheritsFrom: aCoder behavior).
	self assert: aDummyDebugger receiver equals: aCoder behavior instanceSide.

	^ aCoder
]

{ #category : #'examples - debug' }
GtPharoMethodCoderExamples >> debugClassUnaryMethodPointCreation [
	<gtExample>
	| aCoder aCoderViewModel aDummyDebugger |

	aCoder := self coderOnClassUnaryMethodThatCreatesPoint.
	self assert: aCoder isModified.
	
	aCoderViewModel := aCoder asCoderViewModel.
	aCoderViewModel select: 28 to: 46.

	aDummyDebugger := GtPharoDummyDebugger useDuring: [ aCoderViewModel debug ].

	"debugging does not save the method"
	self assert: aCoder isModified.

	self assert: aDummyDebugger sourceCode equals: 'DoIt
	^ aPoint := 196 @ 400'.
	self assert: aDummyDebugger method selector equals: #DoIt.
	self assert: (aDummyDebugger method methodClass inheritsFrom: aCoder behavior).
	self assert: aDummyDebugger receiver equals: aCoder behavior instanceSide.

	^ aCoder
]

{ #category : #'examples - ast' }
GtPharoMethodCoderExamples >> detectReferencesFilterInClassName [
	<gtExample>
	| aCoder aReferencesFilter |
	
	aCoder := self emptyMethodCoder.
	aReferencesFilter := aCoder
		detectReferencesFilterIn: 'Object'
		ifFound: #yourself
		ifNone: [ nil ].

	self assert: aReferencesFilter notNil.
	self assert: aReferencesFilter object equals: (Smalltalk globals associationAt: #Object) .

	^ aReferencesFilter
]

{ #category : #'examples - ast' }
GtPharoMethodCoderExamples >> detectReferencesFilterInEmpty [
	<gtExample>
	| aCoder aReferencesFilter |
	
	aCoder := self emptyMethodCoder.
	aReferencesFilter := aCoder
		detectReferencesFilterIn: ''
		ifFound: #yourself
		ifNone: [ nil ].
		
	self assert: aReferencesFilter isNil.  
		
	^ aReferencesFilter
]

{ #category : #'examples - ast' }
GtPharoMethodCoderExamples >> detectReferencesFilterInKeyword [
	<gtExample>
	| aCoder aReferencesFilter |
	
	aCoder := self emptyMethodCoder.
	aReferencesFilter := aCoder
		detectReferencesFilterIn: 'printOn:'
		ifFound: #yourself
		ifNone: [ nil ].
		
	self assert: aReferencesFilter notNil.
	self assert: aReferencesFilter object equals: #printOn:.

	^ aReferencesFilter
]

{ #category : #'examples - ast' }
GtPharoMethodCoderExamples >> detectReferencesFilterInKeywordWithArgument [
	<gtExample>
	| aCoder aReferencesFilter |
	
	aCoder := self emptyMethodCoder.
	aReferencesFilter := aCoder
		detectReferencesFilterIn: 'printOn: aStream'
		ifFound: #yourself
		ifNone: [ nil ].
		
	self assert: aReferencesFilter notNil.
	self assert: aReferencesFilter object equals: #printOn:.

	^ aReferencesFilter
]

{ #category : #'examples - ast' }
GtPharoMethodCoderExamples >> detectReferencesFilterInMessageSend [
	<gtExample>
	| aCoder aReferencesFilter |
	
	aCoder := self emptyMethodCoder.
	aReferencesFilter := aCoder
		detectReferencesFilterIn: 'Object new'
		ifFound: #yourself
		ifNone: [ nil ].

	self assert: aReferencesFilter notNil.
	self assert: aReferencesFilter object equals: #new.

	^ aReferencesFilter
]

{ #category : #'examples - ast' }
GtPharoMethodCoderExamples >> detectReferencesFilterInUnary [
	<gtExample>
	| aCoder aReferencesFilter |
	
	aCoder := self emptyMethodCoder.
	aReferencesFilter := aCoder
		detectReferencesFilterIn: 'printString'
		ifFound: #yourself
		ifNone: [ nil ].
		
	self assert: aReferencesFilter notNil.
	self assert: aReferencesFilter object equals: #printString.

	^ aReferencesFilter
]

{ #category : #'examples - ast' }
GtPharoMethodCoderExamples >> detectReferencesFilterInWhiteSpace [
	<gtExample>
	| aCoder aReferencesFilter |
	
	aCoder := self emptyMethodCoder.
	aReferencesFilter := aCoder
		detectReferencesFilterIn: ' '
		ifFound: #yourself
		ifNone: [ nil ].
		
	self assert: aReferencesFilter isNil.  
		
	^ aReferencesFilter
]

{ #category : #'sample methods' }
GtPharoMethodCoderExamples >> emptyBody [
]

{ #category : #'sample methods' }
GtPharoMethodCoderExamples >> emptyLines [



"Some empty lines"
]

{ #category : #'examples - instance creation' }
GtPharoMethodCoderExamples >> emptyMethodCoder [
	<gtExample>
	| methodCoder |

	methodCoder := GtPharoMethodCoder new.

	self assert: methodCoder behavior equals: UndefinedObject.
	self assert: methodCoder collapsedText asString equals: ''.
	self assert: methodCoder currentSourceString equals: ''.
	self assert: methodCoder selector equals: nil.
	self assert: methodCoder currentSelector equals: #faulty.

	^ methodCoder
]

{ #category : #'examples - evaluate' }
GtPharoMethodCoderExamples >> evaluateClassUnaryMethodAll [
	<gtExample>
	| aCoder aCoderViewModel aResult |
	
	aCoder := self coderOnClassUnaryMethodThatCreatesPoint.
	self assert: aCoder isModified.

	aCoderViewModel := aCoder asCoderViewModel.

	aResult := aCoderViewModel doIt.

	"evaluating code does not save the method"
	self assert: aCoder isModified.
	self assert: aResult isSuccess. 
	self assert: aResult value equals: 14@20.

	^ aCoder
]

{ #category : #'examples - evaluate' }
GtPharoMethodCoderExamples >> evaluateClassUnaryMethodMethodPointCreation [
	<gtExample>
	| aCoder aCoderViewModel aResult |
	
	aCoder := self coderOnClassUnaryMethodThatCreatesPoint.
	self assert: aCoder isModified.

	aCoderViewModel := aCoder asCoderViewModel.
	aCoderViewModel select: 28 to: 46.

	aResult := aCoderViewModel doIt.

	"evaluating code does not save the method"
	self assert: aCoder isModified.
	self assert: aResult isSuccess. 
	self assert: aResult value equals: 196@400.

	^ aCoder
]

{ #category : #'sample methods' }
GtPharoMethodCoderExamples >> example [
	<gtExample>
	
	^ 42
]

{ #category : #'examples - instance creation' }
GtPharoMethodCoderExamples >> forBinaryMethodCoder [
	<gtExample>
	| method methodCoder |
	method := GtPharoMethodCoderExamples >> #?.
	methodCoder := GtPharoMethodCoder forMethod: method.
	self
		assert: (methodCoder sourceCode isKindOf: GtCoderCompiledMethodSourceCode).
	self assert: methodCoder sourceCode compiledMethod equals: method.
	self assert: methodCoder sourceCode hasSourceText not.
	self assert: methodCoder sourceCode hasCollapsedText not.
	self assert: methodCoder selector equals: #?.
	self assert: methodCoder currentSelector equals: #?.
	self assert: methodCoder behavior equals: GtPharoMethodCoderExamples.
	self assert: methodCoder compiledMethod equals: method.
	self assert: methodCoder collapsedText asString equals: '?'.
	self assert: methodCoder sourceCode hasCollapsedText.
	self
		assert: methodCoder sourceText asString
		equals: method sourceCode.
	self assert: methodCoder sourceCode hasSourceText.
	self
		assert: methodCoder currentSourceString
		equals: method sourceCode.
	self assert: methodCoder isModified not.
	^ methodCoder
]

{ #category : #'examples - instance creation' }
GtPharoMethodCoderExamples >> forEmptyBodyMethodCoder [
	<gtExample>
	| method methodCoder |

	method := GtPharoMethodCoderExamples >> #emptyBody.

	methodCoder := GtPharoMethodCoder forMethod: method.

	self assert: methodCoder collapsedText asString equals: 'emptyBody'.
	self assert: methodCoder currentSourceString equals: 'emptyBody'.

	^ methodCoder
]

{ #category : #'examples - instance creation' }
GtPharoMethodCoderExamples >> forEmptyLinesMethodCoder [
	<gtExample>
	| method methodCoder |
	method := GtPharoMethodCoderExamples >> #emptyLines.

	methodCoder := GtPharoMethodCoder forMethod: method.

	self assert: methodCoder collapsedText asString equals: 'emptyLines'.
	self assert: methodCoder currentSourceString equals: method sourceCode.

	^ methodCoder
]

{ #category : #'examples - instance creation' }
GtPharoMethodCoderExamples >> forExampleMethodCoder [
	<gtExample>
	| method methodCoder |
	method := GtPharoMethodCoderExamples >> #example.
	methodCoder := GtPharoMethodCoder forMethod: method.
	self assert: methodCoder selector equals: #example.
	self assert: methodCoder currentSelector equals: #example.
	self assert: methodCoder behavior equals: GtPharoMethodCoderExamples.
	self assert: methodCoder compiledMethod equals: method.
	self assert: methodCoder collapsedText asString equals: 'example'.
	self
		assert: methodCoder currentSourceString
		equals: method sourceCode.
	self
		assert: methodCoder sourceText asString
		equals: method sourceCode.
	self assert: methodCoder isModified not.
	^ methodCoder
]

{ #category : #'examples - instance creation' }
GtPharoMethodCoderExamples >> forKeywordMethodInPackagedClass [
	<gtExample>
	| anEnvironment aDummyMethod aMethod aClass aMethodCoder |

	anEnvironment := GtPharoDummyEnvironment withPackages: 2 classes: 2.
	aDummyMethod := anEnvironment anyDummyKeywordMethod.

	aMethod := aDummyMethod realMethod.
	aClass := aDummyMethod realClass.
	
	aMethodCoder := GtPharoMethodCoder forMethod: aMethod.
	aMethodCoder attributeNamed: #dummyEnvironment put: anEnvironment.
	aMethodCoder attributeNamed: #dummyMethod put: aDummyMethod.

	self assert: aMethodCoder behavior equals: aClass.
	self assert: aMethodCoder methodBehavior equals: (GtMethodCoderBehavior explicit: aClass).
	self assert: aMethodCoder selector equals: aMethod selector.
	self assert: aMethodCoder compiledMethod equals: aMethod.
	self assert: aMethodCoder protocol equals: aDummyMethod protocol.
	self assert: aMethodCoder sourceCode class equals: GtCoderCompiledMethodSourceCode.
	self assert: aMethodCoder sourceCode compiledMethod equals: aMethod.

	^ aMethodCoder
]

{ #category : #'examples - instance creation' }
GtPharoMethodCoderExamples >> forKeywordSelectorMethodCoder [
	<gtExample>
	| method methodCoder |

	method := GtPharoMethodCoderExamples >> #keyword:selector:.

	methodCoder := GtPharoMethodCoder forMethod: method.

	self assert: methodCoder collapsedText asString equals: 'keyword:selector:'.
	self assert: methodCoder currentSourceString equals: method sourceCode.

	^ methodCoder
]

{ #category : #'examples - instance creation' }
GtPharoMethodCoderExamples >> forNewMethod [
	<gtExample>
	| anEnvironment aDummyMethod aMethodCoder aClass |
	
	anEnvironment := GtPharoDummyEnvironment withPackages: 2 classes: 2.
	aDummyMethod := anEnvironment anyDummyUnaryMethod.
	aDummyMethod realMethod removeFromSystem.

	aClass := aDummyMethod realClass.
	
	aMethodCoder := GtPharoMethodCoder forNewMethod: aClass.
	aMethodCoder attributeNamed: #dummyEnvironment put: anEnvironment.
	aMethodCoder attributeNamed: #dummyMethod put: aDummyMethod.

	self assert: aMethodCoder behavior equals: aClass.
	self assert: aMethodCoder collapsedText asString equals: ''.
	self assert: aMethodCoder currentSourceString equals: ''.
	self assert: aMethodCoder selector equals: nil.
	self assert: aMethodCoder currentSelector equals: #faulty.
	self assert: aMethodCoder isModified not.

	^ aMethodCoder
]

{ #category : #'examples - instance creation' }
GtPharoMethodCoderExamples >> forSelfReturnMethodCoder [
	<gtExample>
	| method methodCoder |
	method := GtPharoMethodCoderExamples >> #returnSelf.

	methodCoder := GtPharoMethodCoder forMethod: method.

	self assert: methodCoder collapsedText asString equals: 'returnSelf'.
	self assert: methodCoder currentSourceString equals: method sourceCode.
	^ methodCoder
]

{ #category : #'examples - instance creation' }
GtPharoMethodCoderExamples >> forThisMethodCoder [
	<gtExample>
	| method methodCoder source |
	method := GtPharoMethodCoderExamples >> #forThisMethodCoder.

	methodCoder := GtPharoMethodCoder forMethod: method.

	source := method sourceCode.
	
	self
		assert: methodCoder collapsedText asString
		equals: (source first: (source indexOf: Character cr) - 1).

	self assert: methodCoder currentSourceString equals: method sourceCode.

	^ methodCoder
]

{ #category : #'examples - instance creation' }
GtPharoMethodCoderExamples >> forThisObjectMethodCoder [
	<gtExample>
	| method methodCoder source |
	method := GtPharoMethodCoderExamples >> #forThisMethodCoder.

	methodCoder := GtPharoMethodCoder forObject: GtPharoMethodCoderExamples new andSelector: #forThisMethodCoder.

	source := method sourceCode.
	
	self
		assert: methodCoder collapsedText asString
		equals: (source first: (source indexOf: Character cr) - 1).

	self assert: methodCoder currentSourceString equals: method sourceCode.

	^ methodCoder
]

{ #category : #'examples - instance creation' }
GtPharoMethodCoderExamples >> forUnaryClassMethod [
	<gtExample>
	| anEnvironment aDummyMethod aMethodCoder |

	anEnvironment := GtPharoDummyEnvironment withPackages: 2 classes: 2.
	aDummyMethod := anEnvironment anyDummyUnaryClassMethod.

	aMethodCoder := GtPharoMethodCoder forMethod: aDummyMethod realMethod.
	aMethodCoder attributeNamed: #dummyEnvironment put: anEnvironment.
	aMethodCoder attributeNamed: #dummyMethod put: aDummyMethod.

	self assert: aMethodCoder behavior equals: aDummyMethod realClass class.
	self assert: aMethodCoder methodBehavior equals: (GtMethodCoderBehavior explicit: aDummyMethod realClass class).
	self assert: aMethodCoder selector equals: aDummyMethod selector.
	self assert: aMethodCoder compiledMethod equals: aDummyMethod realMethod.
	self assert: aMethodCoder protocol equals: aDummyMethod protocol.
	self assert: aMethodCoder sourceCode class equals: GtCoderCompiledMethodSourceCode.
	self assert: aMethodCoder sourceCode compiledMethod equals: aDummyMethod realMethod.

	^ aMethodCoder
]

{ #category : #'examples - instance creation' }
GtPharoMethodCoderExamples >> forUnaryInstanceMethod [
	<gtExample>
	| anEnvironment aDummyMethod aMethod aClass aMethodCoder |

	anEnvironment := GtPharoDummyEnvironment withPackages: 2 classes: 2.
	aDummyMethod := anEnvironment anyDummyUnaryMethod.

	aMethod := aDummyMethod realMethod.
	aClass := aDummyMethod realClass.
	
	aMethodCoder := GtPharoMethodCoder forMethod: aMethod.
	aMethodCoder attributeNamed: #dummyEnvironment put: anEnvironment.
	aMethodCoder attributeNamed: #dummyMethod put: aDummyMethod.

	self assert: aMethodCoder behavior equals: aClass.
	self assert: aMethodCoder methodBehavior equals: (GtMethodCoderBehavior explicit: aClass).
	self assert: aMethodCoder selector equals: aMethod selector.
	self assert: aMethodCoder compiledMethod equals: aMethod.
	self assert: aMethodCoder protocol equals: aDummyMethod protocol.
	self assert: aMethodCoder sourceCode class equals: GtCoderCompiledMethodSourceCode.
	self assert: aMethodCoder sourceCode compiledMethod equals: aMethod.

	^ aMethodCoder
]

{ #category : #'sample methods' }
GtPharoMethodCoderExamples >> keyword: a selector: b [
	^ a + b
]

{ #category : #'sample methods' }
GtPharoMethodCoderExamples >> methodSourceWithTempAndBlockArgsConflict [
	^ 'method
	| each |
	each := #().
	each collect: [ :each | each ].
	^ each'
]

{ #category : #'examples - modification' }
GtPharoMethodCoderExamples >> modifyBackCompiledMethodWithoutCoderModifiedWhenSubscribedToSystem [
	<gtExample>
	| aMethodCoder anOldMethod aNewMethod |
	
	aMethodCoder := self compileMethodWithoutCoderModifiedWhenSubscribedToSystem.
	anOldMethod := (aMethodCoder attributeNamed: #dummyMethod) realMethod.
	aNewMethod := aMethodCoder compiledMethod.
	
	self assert: aMethodCoder isModified.
	
	aMethodCoder
		deleteSourceTextFrom: aMethodCoder sourceText size - '"modified"' size + 1
		to: aMethodCoder sourceText size.
	
	self assert: aMethodCoder isModified.

	self assert: aMethodCoder currentSourceString equals: anOldMethod sourceCode.
	self assert: aMethodCoder sourceCode class equals: GtCoderCompiledMethodSourceCode.
	self assert: aMethodCoder sourceCode sourceString equals: anOldMethod sourceCode.
	self assert: aMethodCoder sourceCode buildSourceText asString equals: anOldMethod sourceCode, '"new method"'.
	self assert: aMethodCoder sourceCode buildSourceText asString equals: aNewMethod sourceCode.
	
	aMethodCoder appendString: '"new method"'.
	
	self assert: aMethodCoder isModified not.

	self assert: aMethodCoder currentSourceString equals: aNewMethod sourceCode.
	self assert: aMethodCoder sourceCode class equals: GtCoderCompiledMethodSourceCode.
	self assert: aMethodCoder sourceCode sourceString equals: aNewMethod sourceCode.
	self assert: aMethodCoder sourceCode buildSourceText asString equals: anOldMethod sourceCode, '"new method"'.
	self assert: aMethodCoder sourceCode buildSourceText asString equals: aNewMethod sourceCode.
	
	^ aMethodCoder
]

{ #category : #'examples - modification' }
GtPharoMethodCoderExamples >> modifyNewMethod [
	<gtExample>
	| aMethodCoder aMethodName anEventsRecoder |

	aMethodCoder := self forNewMethod.
	aMethodName := (aMethodCoder attributeNamed: #dummyMethod) selector.
	
	anEventsRecoder := self eventsRecorder.

	aMethodCoder
		when: GtCoderAnnouncement send: #record: to: anEventsRecoder.

	self assert: aMethodCoder isModified not.
	aMethodCoder appendString: aMethodName.
	
	self assert: anEventsRecoder numberOfEvents equals: 2.
	self assert: anEventsRecoder first class equals: GtCoderSourceCodeChanged.
	self assert: anEventsRecoder first coder equals: aMethodCoder.
	self assert: anEventsRecoder first isSynchronous not.
	self assert: anEventsRecoder second class equals: GtCoderCollapsedLabelChanged.
	self assert: anEventsRecoder second coder equals: aMethodCoder.

	self assert: aMethodCoder isModified.
	self assert: aMethodCoder selector equals: nil.
	self assert: aMethodCoder currentSelector equals: aMethodName.

	self assert: aMethodCoder currentSourceString equals: aMethodName.
	self assert: aMethodCoder sourceCode class equals: GtCoderExplicitSourceCode.
	self assert: aMethodCoder sourceCode source equals: ''.
	self assert: aMethodCoder sourceCode sourceString equals: aMethodName.
	self assert: aMethodCoder sourceCode buildSourceText asString equals: ''.

	^ aMethodCoder
]

{ #category : #'examples - ast' }
GtPharoMethodCoderExamples >> nodeAtCursor [
	<gtExample>
	| coder node |

	coder := GtPharoMethodCoder
		forMethod: GtPharoMethodCoderExamples >> #sampleMethodWithCascades.
	
	node := coder
		nodeAt: ((coder currentSourceString indexOfSubCollection: 'self') - 1)
		ifFound: [ :aNode | aNode ]
		ifNone: [ nil ].
	self assert: (node isKindOf: GtPharoVariableNode) not.
	
	node := coder
		nodeAt: ((coder currentSourceString indexOfSubCollection: 'self') + 4)
		ifFound: [ :aNode | aNode ]
		ifNone: [ nil ].
	self assert: (node isKindOf: GtPharoVariableNode) not.
	
	node := coder
		nodeAt: ((coder currentSourceString indexOfSubCollection: 'self'))
		ifFound: [ :aNode | aNode ]
		ifNone: [ nil ].
	self assert: node isSelf.

	node := coder
		nodeAt: ((coder currentSourceString indexOfSubCollection: 'self') + 3)
		ifFound: [ :aNode | aNode ]
		ifNone: [ nil ].
	self assert: node isSelf.

	^ node
]

{ #category : #'sample methods' }
GtPharoMethodCoderExamples >> notAnExample [
	^ 42
]

{ #category : #'examples - instance creation' }
GtPharoMethodCoderExamples >> orderedCollectionMethods [
	<gtExample>
	| class |
	class := OrderedCollection.
	^ class selectors asSortedCollection collect: [ :each | GtPharoMethodCoder forMethod: class >> each ]
]

{ #category : #'sample methods' }
GtPharoMethodCoderExamples >> printStringReference [
	^ self printString
]

{ #category : #'examples - remove class' }
GtPharoMethodCoderExamples >> removeClassWhenSubscribedToSystem [
	<gtExample>
	| aMethod aMethodCoder anEventsRecoder |

	anEventsRecoder := self eventsRecorder.

	aMethodCoder := self forUnaryInstanceMethod.
	aMethodCoder subscribeToSystem.
	
	aMethod := aMethodCoder compiledMethod.
	
	aMethodCoder when: GtCoderClassRemoved send: #record: to: anEventsRecoder.

	[ GtPharoCodeModifier removeBehavior: aMethodCoder behavior ] ensure: [
		aMethodCoder unsubscribeFromSystem ].

	self assert: aMethodCoder behavior equals: UndefinedObject.
	self assert: aMethodCoder methodBehavior equals: (GtMethodCoderBehavior named: (aMethodCoder attributeNamed: #dummyMethod) className).
	self assert: aMethodCoder selector equals: aMethod selector.
	self assert: aMethodCoder compiledMethod equals: nil.
	self assert: aMethodCoder existsInTheSystem not.
	
	self assert: anEventsRecoder numberOfEvents equals: 1.
	self assert: anEventsRecoder first class equals: GtCoderClassRemoved.
	self assert: anEventsRecoder first coder equals: aMethodCoder.

	^ aMethodCoder
]

{ #category : #'examples - remove method' }
GtPharoMethodCoderExamples >> removeMethodWithCoderWhenSubscribedToSystem [
	<gtExample>
	| aMethodCoder anEventsRecoder |

	anEventsRecoder := self eventsRecorder.

	aMethodCoder := self forUnaryInstanceMethod.
	aMethodCoder subscribeToSystem.
	aMethodCoder weak
		when: GtCoderMethodRemoved
		send: #record:
		to: anEventsRecoder.

	[ aMethodCoder remove ]
		ensure: [ aMethodCoder unsubscribeFromSystem ].

	"when the method is removed using coder's api we reset the state of the coder"
	self assert: aMethodCoder behavior equals: UndefinedObject.
	self assert: aMethodCoder methodBehavior equals: GtMethodCoderBehavior unspecified.
	self assert: aMethodCoder selector equals: nil.
	self assert: aMethodCoder protocol equals: nil.
	self assert: aMethodCoder compiledMethod equals: nil.
	self assert: aMethodCoder existsInTheSystem not.

	self assert: anEventsRecoder numberOfEvents equals: 1.
	self assert: anEventsRecoder first class equals: GtCoderMethodRemoved.
	self assert: anEventsRecoder first coder equals: aMethodCoder.

	^ aMethodCoder
]

{ #category : #'examples - remove method' }
GtPharoMethodCoderExamples >> removeMethodWithoutCoderWhenSubscribedToSystem [
	<gtExample>
	| aMethod aMethodCoder anEventsRecoder |

	anEventsRecoder := self eventsRecorder.

	aMethodCoder := self forUnaryInstanceMethod.
	aMethodCoder subscribeToSystem.

	aMethod := aMethodCoder compiledMethod.

	aMethodCoder weak
		when: GtCoderMethodRemoved send: #record: to: anEventsRecoder.

	[ GtPharoCodeModifier removeMethod: aMethod ] ensure: [
		aMethodCoder unsubscribeFromSystem ].

	"when the method is removed not via coder's api we do not reset the state of the coder,
	allowing users to maybe re-install the method"
	self assert: aMethodCoder behavior equals: aMethod methodClass.
	self assert: aMethodCoder methodBehavior equals: (GtMethodCoderBehavior explicit: (aMethodCoder attributeNamed: #dummyMethod) realClass).
	self assert: aMethodCoder selector equals: aMethod selector.
	self assert: aMethodCoder protocol equals: (aMethodCoder attributeNamed: #dummyMethod) protocol.
	self assert: aMethodCoder compiledMethod equals: nil.
	self assert: aMethodCoder existsInTheSystem not.

	self assert: anEventsRecoder numberOfEvents equals: 1.
	self assert: anEventsRecoder first class equals: GtCoderMethodRemoved.
	self assert: anEventsRecoder first coder equals: aMethodCoder.

	^ aMethodCoder
]

{ #category : #'examples - remove package' }
GtPharoMethodCoderExamples >> removePackageWhenSubscribedToSystem [
	<gtExample>
	| aMethodCoder aMethod aPackage anEventsRecoder |

	anEventsRecoder := self eventsRecorder.

	aMethodCoder := self forUnaryInstanceMethod.
	aMethodCoder subscribeToSystem.
	
	aMethod := aMethodCoder compiledMethod.
	aPackage := aMethod methodClass package.

	aMethodCoder when: GtCoderClassRemoved send: #record: to: anEventsRecoder.

	[ GtPharoCodeModifier removePackage: aPackage ] ensure: [
		aMethodCoder unsubscribeFromSystem ].

	self assert: aMethodCoder behavior equals: UndefinedObject.
	self assert: aMethodCoder methodBehavior equals: (GtMethodCoderBehavior named: (aMethodCoder attributeNamed: #dummyMethod) className).
	self assert: aMethodCoder selector equals: aMethod selector.
	self assert: aMethodCoder compiledMethod equals: nil.
	self assert: aMethodCoder existsInTheSystem not.

	self assert: anEventsRecoder numberOfEvents equals: 1.
	self assert: anEventsRecoder first class equals: GtCoderClassRemoved.
	self assert: anEventsRecoder first coder equals: aMethodCoder.

	^ aMethodCoder
]

{ #category : #'sample methods' }
GtPharoMethodCoderExamples >> returnSelf [ ^self
]

{ #category : #'sample methods' }
GtPharoMethodCoderExamples >> sampleMethodWithCascades [
	| stream |
	stream := WriteStream on: String new.
	stream
		print: self;
		cr;
		nextPutAll: 'Testing';
		next: 4 put: Character space.
	^ stream contents
]

{ #category : #'sample methods' }
GtPharoMethodCoderExamples >> sumMethod [
	<gtExample>
	"sum two numbers"
	self assert: 21 + 21 equals: 42.
	^ 42
]

{ #category : #'examples - validate syntax' }
GtPharoMethodCoderExamples >> validateSyntaxTempArgAndBlockArgsConflict [
	<gtExample>
	| aMethodCoder anEventsRecoder isSyntaxValid |

	anEventsRecoder := self eventsRecorder.

	aMethodCoder := self forNewMethod.
	aMethodCoder currentSourceString: self methodSourceWithTempAndBlockArgsConflict.
	
	aMethodCoder subscribeToSystem.
	aMethodCoder when: GtCoderParseError send: #record: to: anEventsRecoder.

	isSyntaxValid := [ aMethodCoder validateSyntax ] ensure: [
		aMethodCoder unsubscribeFromSystem ].

	"tmp and block conflict is not a syntax error, it is a semantic error (at least now)"
	self assert: isSyntaxValid.
	self assert: anEventsRecoder isEmpty.

	^ aMethodCoder
]
