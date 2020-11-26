Class {
	#name : #GtMethodCoderExamples,
	#superclass : #GtCoderModelExamples,
	#category : #'GToolkit-Coder-Examples-Coders'
}

{ #category : #'sample methods' }
GtMethodCoderExamples >> ? anObject [
	"Test binary method"
]

{ #category : #'sample methods' }
GtMethodCoderExamples >> a [
	<gtExample>
	^ 42
]

{ #category : #'sample methods' }
GtMethodCoderExamples >> a: arg1 a: arg2 a: arg3 a: arg4 [
	"test method for highlighting implementors"
]

{ #category : #'sample methods' }
GtMethodCoderExamples >> b [
	<gtExample>
	^ self a * self notAnExample
]

{ #category : #'examples - compile' }
GtMethodCoderExamples >> compileMethodWithCoderModifiedWhenSubscribedToSystem [
	<gtExample>
	<after: #cleanUp>
	| aMethodCoder wasSuccessful anEventsRecoder anOldMethod aNewMethod |
	
	anEventsRecoder := self eventsRecorder.
	
	aMethodCoder := self forMethodInPackagedClass.
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
GtMethodCoderExamples >> compileMethodWithCoderWhenSubscribedToSystem [
	<gtExample>
	<after: #cleanUp>
	| aMethodCoder wasSuccessful anEventsRecoder anOldMethod aNewMethod |
	
	anEventsRecoder := self eventsRecorder.
	
	aMethodCoder := self forMethodInPackagedClass.
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
GtMethodCoderExamples >> compileMethodWithTempAndBlockArgsConflictWhenSubscribedToSystem [
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

	self assert: anEventsRecoder numberOfEvents equals: 1.
	self assert: anEventsRecoder first class equals: GtCoderParseError.
	self assert: anEventsRecoder first coder equals: aMethodCoder.
	self assert: anEventsRecoder first errorMessage equals: 'Temp shadows: each'.
	
	^ aMethodCoder
]

{ #category : #'examples - compile' }
GtMethodCoderExamples >> compileMethodWithoutCoderModifiedWhenSubscribedToSystem [
	<gtExample>
	<after: #cleanUp>
	| aMethodCoder aCompiledSelector anEventsRecoder anOldMethod aNewMethod |
	
	anEventsRecoder := self eventsRecorder.
	
	aMethodCoder := self forMethodInPackagedClass.
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
GtMethodCoderExamples >> compileMethodWithoutCoderNotModifiedWhenSubscribedToSystem [
	<gtExample>
	<after: #cleanUp>
	| aMethodCoder aCompiledSelector anEventsRecoder anOldMethod aNewMethod |
	
	anEventsRecoder := self eventsRecorder.
	
	aMethodCoder := self forMethodInPackagedClass.
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
GtMethodCoderExamples >> compileModifiedNewMethodWithCoderWhenSubscribedToSystem [
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
GtMethodCoderExamples >> compileRemovedMethodWithCoderWhenSubscribedToSystem [
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
GtMethodCoderExamples >> compileRemovedMethodWithoutCoderWhenSubscribedToSystem [
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

{ #category : #'sample methods' }
GtMethodCoderExamples >> emptyBody [
]

{ #category : #'sample methods' }
GtMethodCoderExamples >> emptyLines [



"Some empty lines"
]

{ #category : #'examples - instance creation' }
GtMethodCoderExamples >> emptyMethodCoder [
	<gtExample>
	| methodCoder |

	methodCoder := GtMethodCoder new.

	self assert: methodCoder behavior equals: UndefinedObject.
	self assert: methodCoder collapsedText asString equals: ''.
	self assert: methodCoder currentSourceString equals: ''.
	self assert: methodCoder selector equals: nil.
	self assert: methodCoder currentSelector equals: #faulty.

	^ methodCoder
]

{ #category : #'sample methods' }
GtMethodCoderExamples >> example [
	<gtExample>
	
	^ 42
]

{ #category : #'examples - instance creation' }
GtMethodCoderExamples >> forBinaryMethodCoder [
	<gtExample>
	| method methodCoder |
	method := GtMethodCoderExamples >> #?.
	methodCoder := GtMethodCoder forMethod: method.
	self
		assert: (methodCoder sourceCode isKindOf: GtCoderCompiledMethodSourceCode).
	self assert: methodCoder sourceCode compiledMethod equals: method.
	self assert: methodCoder sourceCode hasSourceText not.
	self assert: methodCoder sourceCode hasCollapsedText not.
	self assert: methodCoder selector equals: #?.
	self assert: methodCoder currentSelector equals: #?.
	self assert: methodCoder behavior equals: GtMethodCoderExamples.
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
	self assert: methodCoder shouldAddOnsBeUpdated.
	^ methodCoder
]

{ #category : #'examples - instance creation' }
GtMethodCoderExamples >> forEmptyBodyMethodCoder [
	<gtExample>
	| method methodCoder |

	method := GtMethodCoderExamples >> #emptyBody.

	methodCoder := GtMethodCoder forMethod: method.

	self assert: methodCoder collapsedText asString equals: 'emptyBody'.
	self assert: methodCoder currentSourceString equals: 'emptyBody'.

	^ methodCoder
]

{ #category : #'examples - instance creation' }
GtMethodCoderExamples >> forEmptyLinesMethodCoder [
	<gtExample>
	| method methodCoder |
	method := GtMethodCoderExamples >> #emptyLines.

	methodCoder := GtMethodCoder forMethod: method.

	self assert: methodCoder collapsedText asString equals: 'emptyLines'.
	self assert: methodCoder currentSourceString equals: method sourceCode.

	^ methodCoder
]

{ #category : #'examples - instance creation' }
GtMethodCoderExamples >> forExampleMethodCoder [
	<gtExample>
	| method methodCoder |
	method := GtMethodCoderExamples >> #example.
	methodCoder := GtMethodCoder forMethod: method.
	self assert: methodCoder selector equals: #example.
	self assert: methodCoder currentSelector equals: #example.
	self assert: methodCoder behavior equals: GtMethodCoderExamples.
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
GtMethodCoderExamples >> forKeywordSelectorMethodCoder [
	<gtExample>
	| method methodCoder |

	method := GtMethodCoderExamples >> #keyword:selector:.

	methodCoder := GtMethodCoder forMethod: method.

	self assert: methodCoder collapsedText asString equals: 'keyword:selector:'.
	self assert: methodCoder currentSourceString equals: method sourceCode.

	^ methodCoder
]

{ #category : #'examples - instance creation' }
GtMethodCoderExamples >> forMethodInPackagedClass [
	<gtExample>
	<after: #cleanUp>
	| aPackage aClass aMethod aMethodCoder |

	aPackage := self fakeRegisteredPackage.
	aClass := (self fakeClassesInFakePackage: aPackage) first.
	aMethod := (self fakeMethodsInFakeClass: aClass) first.

	aMethodCoder := GtMethodCoder forMethod: aMethod.
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
GtMethodCoderExamples >> forNewMethod [
	<gtExample>
	<after: #cleanUp>
	| aMethodCoder aPackage aClass aMethod |

	aPackage := self fakeRegisteredPackage.
	aClass := (self fakeClassesInFakePackage: aPackage) first.
	aMethod := (self fakeMethodsInFakeClass: aClass) first.

	aMethodCoder := GtMethodCoder forNewMethod: aClass.
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
GtMethodCoderExamples >> forSelfReturnMethodCoder [
	<gtExample>
	| method methodCoder |
	method := GtMethodCoderExamples >> #returnSelf.

	methodCoder := GtMethodCoder forMethod: method.

	self assert: methodCoder collapsedText asString equals: 'returnSelf'.
	self assert: methodCoder currentSourceString equals: method sourceCode.
	^ methodCoder
]

{ #category : #'examples - instance creation' }
GtMethodCoderExamples >> forThisMethodCoder [
	<gtExample>
	| method methodCoder source |
	method := GtMethodCoderExamples >> #forThisMethodCoder.

	methodCoder := GtMethodCoder forMethod: method.

	source := method sourceCode.
	
	self
		assert: methodCoder collapsedText asString
		equals: (source first: (source indexOf: Character cr) - 1).

	self assert: methodCoder currentSourceString equals: method sourceCode.

	^ methodCoder
]

{ #category : #'examples - instance creation' }
GtMethodCoderExamples >> forThisObjectMethodCoder [
	<gtExample>
	| method methodCoder source |
	method := GtMethodCoderExamples >> #forThisMethodCoder.

	methodCoder := GtMethodCoder forObject: GtMethodCoderExamples new andSelector: #forThisMethodCoder.

	source := method sourceCode.
	
	self
		assert: methodCoder collapsedText asString
		equals: (source first: (source indexOf: Character cr) - 1).

	self assert: methodCoder currentSourceString equals: method sourceCode.

	^ methodCoder
]

{ #category : #'sample methods' }
GtMethodCoderExamples >> keyword: a selector: b [
	^ a + b
]

{ #category : #'sample methods' }
GtMethodCoderExamples >> methodSourceWithTempAndBlockArgsConflict [
	^ 'method
	| each |
	each := #().
	each collect: [ :each | each ].
	^ each'
]

{ #category : #'examples - modification' }
GtMethodCoderExamples >> modifyBackCompiledMethodWithoutCoderModifiedWhenSubscribedToSystem [
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
GtMethodCoderExamples >> modifyNewMethod [
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
	self assert: anEventsRecoder first class equals: GtCoderCollapsedLabelChanged.
	self assert: anEventsRecoder first coder equals: aMethodCoder.
	self assert: anEventsRecoder second class equals: GtCoderSourceCodeChanged.
	self assert: anEventsRecoder second coder equals: aMethodCoder.
	self assert: anEventsRecoder second isSynchronous not.

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
GtMethodCoderExamples >> nodeAtCursor [
	<gtExample>
	| coder node |

	coder := GtMethodCoder
		forMethod: GtMethodCoderExamples >> #sampleMethodWithCascades.
	
	node := coder rbNodeAt: ((coder currentSourceString indexOfSubCollection: 'self') - 1).
	self assert: node isSelf not.

	node := coder rbNodeAt: ((coder currentSourceString indexOfSubCollection: 'self') + 4).
	self assert: node isSelf not.

	node := coder rbNodeAt: ((coder currentSourceString indexOfSubCollection: 'self')).
	self assert: node isSelf.

	node := coder rbNodeAt: ((coder currentSourceString indexOfSubCollection: 'self') + 3).
	self assert: node isSelf.

	^ node
]

{ #category : #'sample methods' }
GtMethodCoderExamples >> notAnExample [
	^ 42
]

{ #category : #'examples - instance creation' }
GtMethodCoderExamples >> orderedCollectionMethods [
	<gtExample>
	| class |
	class := OrderedCollection.
	^ class selectors asSortedCollection collect: [ :each | GtMethodCoder forMethod: class >> each ]
]

{ #category : #'sample methods' }
GtMethodCoderExamples >> printStringReference [
	^ self printString
]

{ #category : #'examples - remove class' }
GtMethodCoderExamples >> removeClassWhenSubscribedToSystem [
	<gtExample>
	<after: #cleanUp>
	| aMethod aMethodCoder anEventsRecoder |

	anEventsRecoder := self eventsRecorder.

	aMethodCoder := self forMethodInPackagedClass.
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
GtMethodCoderExamples >> removeMethodWithCoderWhenSubscribedToSystem [
	<gtExample>
	<after: #cleanUp>
	| aMethodCoder anEventsRecoder |

	anEventsRecoder := self eventsRecorder.

	aMethodCoder := self forMethodInPackagedClass.
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
GtMethodCoderExamples >> removeMethodWithoutCoderWhenSubscribedToSystem [
	<gtExample>
	<after: #cleanUp>
	| aMethod aMethodCoder anEventsRecoder |

	anEventsRecoder := self eventsRecorder.

	aMethodCoder := self forMethodInPackagedClass.
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
GtMethodCoderExamples >> removePackageWhenSubscribedToSystem [
	<gtExample>
	<after: #cleanUp>
	| aMethodCoder aMethod aPackage anEventsRecoder |

	anEventsRecoder := self eventsRecorder.

	aMethodCoder := self forMethodInPackagedClass.
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
GtMethodCoderExamples >> returnSelf [ ^self
]

{ #category : #'sample methods' }
GtMethodCoderExamples >> sampleMethodWithCascades [
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
GtMethodCoderExamples >> sumMethod [
	<gtExample>
	"sum two numbers"
	self assert: 21 + 21 equals: 42.
	^ 42
]

{ #category : #'examples - validate syntax' }
GtMethodCoderExamples >> validateSyntaxTempArgAndBlockArgsConflict [
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
