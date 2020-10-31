Class {
	#name : #GtMethodCoderExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Model'
}

{ #category : #'sample methods' }
GtMethodCoderExamples >> ? anObject [
	"Test binary method"
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
	| coder |

	coder := GtMethodCoder new.
	
	self assert: coder collapsedText asString equals: ''.
	self assert: coder currentSourceString equals: ''.
	
	self assert: coder selector equals: nil.
	self assert: coder currentSelector equals: #faulty.

	^ coder
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
	method := self class >> #?.

	methodCoder := GtMethodCoder forMethod: method.

	self assert: (methodCoder sourceCode isKindOf: GtCoderCompiledMethodSourceCode).
	self assert: methodCoder sourceCode compiledMethod equals: method.
	self assert: methodCoder sourceCode hasSourceText not.
	self assert: methodCoder sourceCode hasCollapsedText not.

	self assert: methodCoder selector equals: #?.
	self assert: methodCoder currentSelector equals: #?.
	self assert: methodCoder classOrMetaClass equals: self class.
	self assert: methodCoder compiledMethod equals: method.
	
	self assert: methodCoder collapsedText asString equals: '?'.
	self assert: methodCoder sourceCode hasCollapsedText.
	
	self assert: methodCoder sourceText asString equals: method sourceCode.
	self assert: methodCoder sourceCode hasSourceText.

	self assert: methodCoder currentSourceString equals: method sourceCode.

	self assert: methodCoder isModified not.
	self assert: methodCoder shouldAddOnsBeUpdated.

	^ methodCoder
]

{ #category : #'examples - instance creation' }
GtMethodCoderExamples >> forEmptyBodyMethodCoder [
	<gtExample>
	| method methodCoder |
	
	method := self class >> #emptyBody.
	
	methodCoder := GtMethodCoder forMethod: method.

	self assert: methodCoder collapsedText asString equals: 'emptyBody'.
	self assert: methodCoder currentSourceString equals: 'emptyBody'.

	^ methodCoder
]

{ #category : #'examples - instance creation' }
GtMethodCoderExamples >> forEmptyLinesMethodCoder [
	<gtExample>
	| method methodCoder |
	method := self class >> #emptyLines.

	methodCoder := GtMethodCoder forMethod: method.

	self assert: methodCoder collapsedText asString equals: 'emptyLines'.
	self assert: methodCoder currentSourceString equals: method sourceCode.

	^ methodCoder
]

{ #category : #'examples - instance creation' }
GtMethodCoderExamples >> forExampleMethodCoder [
	<gtExample>
	| method methodCoder |

	method := self class >> #example.

	methodCoder := GtMethodCoder forMethod: method.

	self assert: methodCoder selector equals: #example.
	self assert: methodCoder currentSelector equals: #example.
	self assert: methodCoder classOrMetaClass equals: self class.
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

	method := self class >> #keyword:selector:.

	methodCoder := GtMethodCoder forMethod: method.

	self assert: methodCoder collapsedText asString equals: 'keyword:selector:'.
	self assert: methodCoder currentSourceString equals: method sourceCode.

	^ methodCoder
]

{ #category : #'examples - instance creation' }
GtMethodCoderExamples >> forNewMethod [
	<gtExample>
	| methodCoder |

	methodCoder := GtMethodCoder newMethod.
	
	self assert: methodCoder classOrMetaClass equals: UndefinedObject.
	
	self assert: methodCoder collapsedText asString equals: ''.
	self assert: methodCoder currentSourceString equals: ''.
	
	self assert: methodCoder selector equals: nil.
	self assert: methodCoder currentSelector equals: #faulty.

	^ methodCoder
]

{ #category : #'examples - instance creation' }
GtMethodCoderExamples >> forSelfReturnMethodCoder [
	<gtExample>
	| method methodCoder |
	method := self class >> #returnSelf.

	methodCoder := GtMethodCoder forMethod: method.

	self assert: methodCoder collapsedText asString equals: 'returnSelf'.
	self assert: methodCoder currentSourceString equals: method sourceCode.
	^ methodCoder
]

{ #category : #'examples - instance creation' }
GtMethodCoderExamples >> forThisMethodCoder [
	<gtExample>
	| method methodCoder source |
	method := self class >> #forThisMethodCoder.

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
	method := self class >> #forThisMethodCoder.

	methodCoder := GtMethodCoder forObject: self class new andSelector: #forThisMethodCoder.

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

{ #category : #'examples - api' }
GtMethodCoderExamples >> nodeAtCursor [
	<gtExample>
	| coder node |

	coder := GtMethodCoder
		forMethod: self class >> #sampleMethodWithCascades.
	
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

{ #category : #'examples - instance creation' }
GtMethodCoderExamples >> orderedCollectionMethods [
	<gtExample>
	| class |
	class := OrderedCollection.
	^ class selectors asSortedCollection collect: [ :each | GtMethodCoder forMethod: class >> each ]
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
