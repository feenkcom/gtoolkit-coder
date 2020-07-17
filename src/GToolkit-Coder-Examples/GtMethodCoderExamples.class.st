Class {
	#name : #GtMethodCoderExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Model'
}

{ #category : #'sample methods' }
GtMethodCoderExamples >> ? anObject [
	"Test binary method"
]

{ #category : #'examples - ui' }
GtMethodCoderExamples >> elementForOrderedCollectionMethods [
	<gtExample>
	| container |
	container := BlElement new.
	container layout: BlLinearLayout vertical.
	container padding: (BlInsets all: 10).
	container
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	container addChildren: (self orderedCollectionMethods collect: [ :each | each asElement ]).
	^ container
]

{ #category : #'examples - ui' }
GtMethodCoderExamples >> elementForThisMethodCoder [
	<gtExample>
	| aCoder aCoderElement |

	aCoder := self forThisMethodCoder.

	aCoderElement := aCoder asElement.
	
	self assert: (aCoderElement isKindOf: GtExpandableCoderElement).

	self assert: aCoder expanded not.
	self assert: aCoderElement isExpanded not.
	aCoderElement expand.

	self assert: aCoder expanded.
	self assert: aCoderElement isExpanded.
	
	^ aCoderElement
]

{ #category : #'sample methods' }
GtMethodCoderExamples >> emptyBody [
]

{ #category : #'sample methods' }
GtMethodCoderExamples >> emptyLines [



"Some empty lines"
]

{ #category : #'examples - default' }
GtMethodCoderExamples >> emptyMethodCoder [
	<gtExample>
	| coder |

	coder := GtMethodCoder new.

	coder classOrMetaClass: Object.
	coder object: nil.
	
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

{ #category : #'examples - for method' }
GtMethodCoderExamples >> forBinaryMethodCoder [
	<gtExample>
	| method methodCoder |
	method := self class >> #?.

	BlUseAsyncFeatures disableDuring: [ 
		methodCoder := GtMethodCoder forMethod: method.
	].
	
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

{ #category : #'examples - for method' }
GtMethodCoderExamples >> forEmptyBodyMethodCoder [
	<gtExample>
	| method methodCoder |
	
	method := self class >> #emptyBody.
	
	BlUseAsyncFeatures disableDuring: [ 
		methodCoder := GtMethodCoder forMethod: method.
	].

	self assert: methodCoder collapsedText asString equals: 'emptyBody'.
	self assert: methodCoder currentSourceString equals: 'emptyBody'.

	^ methodCoder
]

{ #category : #'examples - for method' }
GtMethodCoderExamples >> forEmptyLinesMethodCoder [
	<gtExample>
	| method methodCoder |
	method := self class >> #emptyLines.
	BlUseAsyncFeatures disableDuring: [ 
		methodCoder := GtMethodCoder forMethod: method.
	].

	self assert: methodCoder collapsedText asString equals: 'emptyLines'.
	self assert: methodCoder currentSourceString equals: method sourceCode.

	^ methodCoder
]

{ #category : #'examples - for method' }
GtMethodCoderExamples >> forExampleMethodCoder [
	<gtExample>
	| method methodCoder |

	method := self class >> #example.
	BlUseAsyncFeatures disableDuring: [ 
		methodCoder := GtMethodCoder forMethod: method.
	].
	
	"self assert: methodCoder selector equals: #?.
	self assert: methodCoder currentSelector equals: #?.

	self assert: methodCoder classOrMetaClass equals: self class.
	self assert: methodCoder compiledMethod equals: method.
	
	self assert: methodCoder collapsedSource equals: '?'.
	
	self assert: methodCoder source equals: method sourceCode.
	self assert: methodCoder sourceText asString equals: method sourceCode.

	self assert: methodCoder isModified not."

	^ methodCoder
]

{ #category : #'examples - for method' }
GtMethodCoderExamples >> forKeywordSelectorMethodCoder [
	<gtExample>
	| method methodCoder |
	method := self class >> #keyword:selector:.
	BlUseAsyncFeatures disableDuring: [ 
		methodCoder := GtMethodCoder forMethod: method.
	].

	self assert: methodCoder collapsedText asString equals: 'keyword:selector:'.
	self assert: methodCoder currentSourceString equals: method sourceCode.

	^ methodCoder
]

{ #category : #'examples - for method' }
GtMethodCoderExamples >> forSelfReturnMethodCoder [
	<gtExample>
	| method methodCoder |
	method := self class >> #returnSelf.
	BlUseAsyncFeatures disableDuring: [ 
		methodCoder := GtMethodCoder forMethod: method.
	].

	self assert: methodCoder collapsedText asString equals: 'returnSelf'.
	self assert: methodCoder currentSourceString equals: method sourceCode.
	^ methodCoder
]

{ #category : #'examples - for method' }
GtMethodCoderExamples >> forThisMethodCoder [
	<gtExample>
	| method methodCoder source |
	method := self class >> #forThisMethodCoder.

	BlUseAsyncFeatures
		disableDuring: [ methodCoder := GtMethodCoder forMethod: method ].

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

{ #category : #'examples - for method' }
GtMethodCoderExamples >> orderedCollectionMethods [
	<gtExample>
	| class |
	class := OrderedCollection.
	^ class selectors asSortedCollection collect: [ :each | GtMethodCoder forMethod: class >> each ]
]

{ #category : #'sample methods' }
GtMethodCoderExamples >> returnSelf [ ^self
]
