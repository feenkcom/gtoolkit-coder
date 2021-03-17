Class {
	#name : #GtPharoMethodCoderExamples,
	#superclass : #GtCoderModelExamples,
	#category : #'GToolkit-Coder-Examples-Pharo'
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

{ #category : #'examples - compile' }
GtPharoMethodCoderExamples >> compileMethodWithCoderModifiedWhenSubscribedToSystem [
	<gtExample>
	<after: #cleanUp>
	| aMethodCoder wasSuccessful anEventsRecoder anOldMethod aNewMethod |
	
	anEventsRecoder := self eventsRecorder.
	
	aMethodCoder := self forUnaryMethodInPackagedClass.
	anOldMethod := aMethodCoder attributeNamed: #fakeMethod.
	
	aMethodCoder sourceText append: '"modified"' asRopedText.
	aMethodCoder subscribeToSystem.
	
	self assert: aMethodCoder isModified.
	self assert: aMethodCoder currentSourceString equals: anOldMethod sourceCode, '"modified"'.
	
	aMethodCoder
		when: GtCoderClassRemoved send: #record: to: anEventsRecoder;
		when: GtCoderMethodAdded send: #record: to: anEventsRecoder;
		when: GtCoderMethodModified send: #record: to: anEventsRecoder;
		when: GtCoderMethodRemoved send: #record: to: anEventsRecoder.

	wasSuccessful := [ aMethodCoder compile ]
		ensure: [ aMethodCoder unsubscribeFromSystem ].
	
	self assert: wasSuccessful.
	aNewMethod := (aMethodCoder attributeNamed: #fakeClass) >> anOldMethod selector.

	self assert: aMethodCoder behavior equals: (aMethodCoder attributeNamed: #fakeClass).
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
	<after: #cleanUp>
	| aMethodCoder wasSuccessful anEventsRecoder anOldMethod aNewMethod |
	
	anEventsRecoder := self eventsRecorder.
	
	aMethodCoder := self forUnaryMethodInPackagedClass.
	anOldMethod := aMethodCoder attributeNamed: #fakeMethod.
	
	aMethodCoder subscribeToSystem.
	
	self assert: aMethodCoder isModified not.
	self assert: aMethodCoder currentSourceString equals: anOldMethod sourceCode.
	
	aMethodCoder
		when: GtCoderClassRemoved send: #record: to: anEventsRecoder;
		when: GtCoderMethodAdded send: #record: to: anEventsRecoder;
		when: GtCoderMethodModified send: #record: to: anEventsRecoder;
		when: GtCoderMethodRemoved send: #record: to: anEventsRecoder.

	wasSuccessful := [ aMethodCoder compile ]
		ensure: [ aMethodCoder unsubscribeFromSystem ].
	
	self assert: wasSuccessful.
	aNewMethod := (aMethodCoder attributeNamed: #fakeClass) >> anOldMethod selector.

	self assert: aMethodCoder behavior equals: (aMethodCoder attributeNamed: #fakeClass).
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
	<after: #cleanUp>
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
	<after: #cleanUp>
	| aMethodCoder aCompiledSelector anEventsRecoder anOldMethod aNewMethod |
	
	anEventsRecoder := self eventsRecorder.
	
	aMethodCoder := self forUnaryMethodInPackagedClass.
	anOldMethod := aMethodCoder attributeNamed: #fakeMethod.
	
	aMethodCoder sourceText append: '"modified"' asRopedText.
	aMethodCoder subscribeToSystem.
	
	self assert: aMethodCoder isModified.
	self assert: aMethodCoder currentSourceString equals: anOldMethod sourceCode, '"modified"'.
	
	aMethodCoder
		when: GtCoderClassRemoved send: #record: to: anEventsRecoder;
		when: GtCoderMethodAdded send: #record: to: anEventsRecoder;
		when: GtCoderMethodModified send: #record: to: anEventsRecoder;
		when: GtCoderMethodRemoved send: #record: to: anEventsRecoder.

	aCompiledSelector := [ anOldMethod methodClass compile: anOldMethod sourceCode, '"new method"' classified: anOldMethod protocol ]
		ensure: [ aMethodCoder unsubscribeFromSystem ].
	
	self assert: aCompiledSelector equals: anOldMethod selector.
	aNewMethod := (aMethodCoder attributeNamed: #fakeClass) >> aCompiledSelector.

	self assert: aMethodCoder behavior equals: (aMethodCoder attributeNamed: #fakeClass).
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
	<after: #cleanUp>
	| aMethodCoder aCompiledSelector anEventsRecoder anOldMethod aNewMethod |
	
	anEventsRecoder := self eventsRecorder.
	
	aMethodCoder := self forUnaryMethodInPackagedClass.
	aMethodCoder subscribeToSystem.
	
	self assert: aMethodCoder isModified not.
	
	aMethodCoder
		when: GtCoderClassRemoved send: #record: to: anEventsRecoder;
		when: GtCoderMethodAdded send: #record: to: anEventsRecoder;
		when: GtCoderMethodModified send: #record: to: anEventsRecoder;
		when: GtCoderMethodRemoved send: #record: to: anEventsRecoder.

	anOldMethod := aMethodCoder attributeNamed: #fakeMethod.

	aCompiledSelector := [ anOldMethod methodClass compile: anOldMethod sourceCode, '"new method"' classified: anOldMethod protocol ]
		ensure: [ aMethodCoder unsubscribeFromSystem ].
	
	self assert: aCompiledSelector equals: anOldMethod selector.
	aNewMethod := (aMethodCoder attributeNamed: #fakeClass) >> aCompiledSelector.

	self assert: aMethodCoder behavior equals: (aMethodCoder attributeNamed: #fakeClass).
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
	<after: #cleanUp>
	| aMethodCoder wasSuccessful anEventsRecoder aNewMethodSelector aNewMethod |
	
	anEventsRecoder := self eventsRecorder.
	
	aMethodCoder := self modifyNewMethod.
	
	aMethodCoder subscribeToSystem.
	
	self assert: aMethodCoder isModified.
	aNewMethodSelector := aMethodCoder attributeNamed: #fakeMethodName.
	
	aMethodCoder
		when: GtCoderClassRemoved send: #record: to: anEventsRecoder;
		when: GtCoderMethodAdded send: #record: to: anEventsRecoder;
		when: GtCoderMethodModified send: #record: to: anEventsRecoder;
		when: GtCoderMethodRemoved send: #record: to: anEventsRecoder.

	wasSuccessful := [ aMethodCoder compile ]
		ensure: [ aMethodCoder unsubscribeFromSystem ].
	
	self assert: wasSuccessful.
	aNewMethod := (aMethodCoder attributeNamed: #fakeClass) >> aNewMethodSelector.

	self assert: aMethodCoder behavior equals: (aMethodCoder attributeNamed: #fakeClass).
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
	<after: #cleanUp>
	| aMethodCoder aCompileChange aCompilationResult anEventsRecoder |
	
	anEventsRecoder := self eventsRecorder.
	
	aMethodCoder := self removeMethodWithCoderWhenSubscribedToSystem.
	aMethodCoder subscribeToSystem.

	aCompileChange := aMethodCoder createCompileMethodChange.
	self assert: aCompileChange equals: nil.

	aMethodCoder
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
	<after: #cleanUp>
	| aMethodCoder aCompileChange aCompilationResult anEventsRecoder |
	
	anEventsRecoder := self eventsRecorder.
	
	aMethodCoder := self removeMethodWithoutCoderWhenSubscribedToSystem.
	aMethodCoder subscribeToSystem.
	
	aCompileChange := aMethodCoder createCompileMethodChange.
	self assert: aCompileChange changeClass equals: (aMethodCoder attributeNamed: #fakeClass).
	self assert: aCompileChange selector equals: (aMethodCoder attributeNamed: #fakeMethod) selector.
	self assert: aCompileChange protocol equals: (aMethodCoder attributeNamed: #fakeProtocol).
	self assert: aCompileChange isMeta not.
	
	aMethodCoder
		when: GtCoderClassRemoved send: #record: to: anEventsRecoder;
		when: GtCoderMethodAdded send: #record: to: anEventsRecoder;
		when: GtCoderMethodRemoved send: #record: to: anEventsRecoder.

	aCompilationResult := [ aMethodCoder compile ]
		ensure: [ aMethodCoder unsubscribeFromSystem ].
	
	self assert: aCompilationResult.

	self assert: aMethodCoder behavior equals: (aMethodCoder attributeNamed: #fakeClass).
	self assert: aMethodCoder selector equals: (aMethodCoder attributeNamed: #fakeMethod) selector.
	self assert: aMethodCoder compiledMethod equals: (aMethodCoder attributeNamed: #fakeMethod).
	self assert: aMethodCoder protocol equals: (aMethodCoder attributeNamed: #fakeProtocol).
	self assert: aMethodCoder existsInTheSystem.

	self assert: anEventsRecoder numberOfEvents equals: 1.
	self assert: anEventsRecoder first class equals: GtCoderMethodAdded.
	self assert: anEventsRecoder first coder equals: aMethodCoder.
	
	^ aMethodCoder
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
	<after: #cleanUp>
	| aPackage aClass aMethod aMethodCoder |

	aPackage := self fakeRegisteredPackage.
	aClass := (self fakeClassesInFakePackage: aPackage) first.
	aMethod := (self fakeKeywordMethodsInFakeClass: aClass) first.

	aMethodCoder := GtPharoMethodCoder forMethod: aMethod.
	aMethodCoder attributeNamed: #fakePackage put: aPackage.
	aMethodCoder attributeNamed: #fakeClass put: aClass.
	aMethodCoder attributeNamed: #fakeClassName put: aClass name.
	aMethodCoder attributeNamed: #fakeMethod put: aMethod.
	aMethodCoder attributeNamed: #fakeMethodName put: aMethod selector.
	aMethodCoder attributeNamed: #fakeProtocol put: (self fakeCategoryForFakeMethod: aMethod).
	aMethodCoder attributeNamed: #fakeInstVarNames put: aClass instVarNames.

	self assert: aMethodCoder behavior equals: aClass.
	self assert: aMethodCoder methodBehavior equals: (GtMethodCoderBehavior explicit: aClass).
	self assert: aMethodCoder selector equals: aMethod selector.
	self assert: aMethodCoder compiledMethod equals: aMethod.
	self assert: aMethodCoder protocol equals: (self fakeCategoryForFakeMethod: aMethod).
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
	<after: #cleanUp>
	| aMethodCoder aPackage aClass aMethod |

	aPackage := self fakeRegisteredPackage.
	aClass := (self fakeClassesInFakePackage: aPackage) first.
	aMethod := (self fakeMethodsInFakeClass: aClass) first.

	aMethodCoder := GtPharoMethodCoder forNewMethod: aClass.
	aMethodCoder attributeNamed: #fakePackage put: aPackage.
	aMethodCoder attributeNamed: #fakeClass put: aClass.
	aMethodCoder attributeNamed: #fakeClassName put: aClass name.
	aMethodCoder attributeNamed: #fakeMethodName put: (aMethod selector, 'New').
	aMethodCoder attributeNamed: #fakeInstVarNames put: aClass instVarNames.

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
GtPharoMethodCoderExamples >> forUnaryMethodInPackagedClass [
	<gtExample>
	<after: #cleanUp>
	| aPackage aClass aMethod aMethodCoder |

	aPackage := self fakeRegisteredPackage.
	aClass := (self fakeClassesInFakePackage: aPackage) first.
	aMethod := (self fakeUnaryMethodsInFakeClass: aClass) first.

	aMethodCoder := GtPharoMethodCoder forMethod: aMethod.
	aMethodCoder attributeNamed: #fakePackage put: aPackage.
	aMethodCoder attributeNamed: #fakeClass put: aClass.
	aMethodCoder attributeNamed: #fakeClassName put: aClass name.
	aMethodCoder attributeNamed: #fakeMethod put: aMethod.
	aMethodCoder attributeNamed: #fakeMethodName put: aMethod selector.
	aMethodCoder attributeNamed: #fakeProtocol put: (self fakeCategoryForFakeMethod: aMethod).
	aMethodCoder attributeNamed: #fakeInstVarNames put: aClass instVarNames.

	self assert: aMethodCoder behavior equals: aClass.
	self assert: aMethodCoder methodBehavior equals: (GtMethodCoderBehavior explicit: aClass).
	self assert: aMethodCoder selector equals: aMethod selector.
	self assert: aMethodCoder compiledMethod equals: aMethod.
	self assert: aMethodCoder protocol equals: (self fakeCategoryForFakeMethod: aMethod).
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
	<after: #cleanUp>
	| aMethodCoder anOldMethod aNewMethod |
	
	aMethodCoder := self compileMethodWithoutCoderModifiedWhenSubscribedToSystem.
	anOldMethod := aMethodCoder attributeNamed: #fakeMethod.
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
	<after: #cleanUp>
	| aMethodCoder aMethodName anEventsRecoder |

	aMethodCoder := self forNewMethod.
	aMethodName := aMethodCoder attributeNamed: #fakeMethodName.
	
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

{ #category : #'examples - api' }
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
	<after: #cleanUp>
	| aMethod aMethodCoder anEventsRecoder |

	anEventsRecoder := self eventsRecorder.

	aMethodCoder := self forUnaryMethodInPackagedClass.
	aMethodCoder subscribeToSystem.
	
	aMethod := aMethodCoder compiledMethod.
	
	aMethodCoder when: GtCoderClassRemoved send: #record: to: anEventsRecoder.

	[ aMethodCoder behavior removeFromSystem ] ensure: [
		aMethodCoder unsubscribeFromSystem ].

	self assert: aMethodCoder behavior equals: UndefinedObject.
	self assert: aMethodCoder methodBehavior equals: (GtMethodCoderBehavior named: (aMethodCoder attributeNamed: #fakeClassName)).
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
	<after: #cleanUp>
	| aMethodCoder anEventsRecoder |

	anEventsRecoder := self eventsRecorder.

	aMethodCoder := self forUnaryMethodInPackagedClass.
	aMethodCoder subscribeToSystem.
	aMethodCoder
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
	<after: #cleanUp>
	| aMethod aMethodCoder anEventsRecoder |

	anEventsRecoder := self eventsRecorder.

	aMethodCoder := self forUnaryMethodInPackagedClass.
	aMethodCoder subscribeToSystem.

	aMethod := aMethodCoder compiledMethod.

	aMethodCoder when: GtCoderMethodRemoved send: #record: to: anEventsRecoder.

	[ aMethod removeFromSystem ] ensure: [
		aMethodCoder unsubscribeFromSystem ].

	"when the method is removed not via coder's api we do not reset the state of the coder,
	allowing users to maybe re-install the method"
	self assert: aMethodCoder behavior equals: aMethod methodClass.
	self assert: aMethodCoder methodBehavior equals: (GtMethodCoderBehavior explicit: (aMethodCoder attributeNamed: #fakeClass)).
	self assert: aMethodCoder selector equals: aMethod selector.
	self assert: aMethodCoder protocol equals: (aMethodCoder attributeNamed: #fakeProtocol).
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
	<after: #cleanUp>
	| aMethodCoder aMethod aPackage anEventsRecoder |

	anEventsRecoder := self eventsRecorder.

	aMethodCoder := self forUnaryMethodInPackagedClass.
	aMethodCoder subscribeToSystem.
	
	aMethod := aMethodCoder compiledMethod.
	aPackage := aMethod methodClass package.

	aMethodCoder when: GtCoderClassRemoved send: #record: to: anEventsRecoder.

	[ aPackage removeFromSystem ] ensure: [
		aMethodCoder unsubscribeFromSystem ].

	self assert: aMethodCoder behavior equals: UndefinedObject.
	self assert: aMethodCoder methodBehavior equals: (GtMethodCoderBehavior named: (aMethodCoder attributeNamed: #fakeClassName)).
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
	<after: #cleanUp>
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