Class {
	#name : #GtMethodCoderByScripterExamples,
	#superclass : #GtCoderExamples,
	#category : #'GToolkit-Coder-Examples'
}

{ #category : #'sample methods' }
GtMethodCoderByScripterExamples >> ? anObject [
	"Test binary method"
]

{ #category : #'examples - basic' }
GtMethodCoderByScripterExamples >> basicMethodCoder [
	<gtExample>
	| aCoder |
	aCoder := GtMethodCoder new.
	self assert: aCoder selector isNil.
	self assert: aCoder classOrMetaClass equals: UndefinedObject.
	self assert: aCoder category isNil.
	self assert: aCoder source isString.
	self assert: aCoder source isEmpty.
	^ aCoder
]

{ #category : #'examples - binary method' }
GtMethodCoderByScripterExamples >> binaryMethod [
	<gtExample>
	^ self class >> #?
]

{ #category : #'examples - binary method' }
GtMethodCoderByScripterExamples >> binaryMethodCoder [
	<gtExample>
	| aMethod aCoder |
	aMethod := self binaryMethod.
	aCoder := self basicMethodCoder.
	aCoder forMethod: aMethod.
	self assert: aCoder selector equals: '?'.
	self assert: aCoder classOrMetaClass equals: self class.
	self assert: aCoder category equals: aMethod protocol.
	self assert: aCoder source isString.
	self assert: aCoder expanded not.
	"Source code is empty as Coder is not displayed yet."
	self assert: aCoder isBuilt not.
	self assert: aCoder source isEmpty.
	self assert: aCoder collapsedSource isEmpty.
	^ aCoder
]

{ #category : #'examples - binary method' }
GtMethodCoderByScripterExamples >> binaryMethodCoderUI [
	<gtExample>
	| aScripter |
	aScripter := self scripter.
	aScripter substep: 'Initialize Model and UI' do: [ :aStep | 
		aStep set 
			label: 'Initialize Coder';
			model: [ self binaryMethodCoder ].
		aStep set 
			label: 'Initialize Coder UI';
			element: [ :aCoder | aCoder asElement ];
			onModel ].
	aScripter syncContinue.
	^ aScripter
]

{ #category : #'examples - binary method' }
GtMethodCoderByScripterExamples >> binaryMethodCoderUI_CollapsedByDefault [
	<gtExample>
	| aScripter |
	aScripter := self binaryMethodCoderUI.
	aScripter checks: 'Check Sources' do: [ :aStep |
		aStep check
			label: 'Check Expanded Source';
			satisfies: [ :aCoder | aCoder source = self binaryMethod sourceCode ];
			onModel.
		aStep check
			label: 'Check Collapsed Source';
			satisfies: [ :aCoder | aCoder collapsedSource = '? anObject' ];
			onModel.
		aStep check
			label: 'Check Coder Editor Text';
			satisfies: [ :anEditorElement | anEditorElement editor text asString = '? anObject' ];
			onChildNamed: #editor ].
	aScripter syncContinue.
	^ aScripter
]

{ #category : #'examples - binary method' }
GtMethodCoderByScripterExamples >> binaryMethodCoderUI_ExpandedFromModel [
	<gtExample>
	| aScripter |
	aScripter := self binaryMethodCoderUI.
	aScripter do
		label: 'Expand Coder';
		action: [ :aCoder | aCoder expanded: true ];
		onModel.
	aScripter check
		label: 'Check Coder Editor Text';
		satisfies: [ :anEditorElement | anEditorElement editor text asString = self binaryMethod sourceCode ];
		onChildNamed: #editor.
	aScripter syncContinue.
	^ aScripter
]

{ #category : #'examples - basic' }
GtMethodCoderByScripterExamples >> methodCoder [
	<gtExample>
	| aScripter |
	aScripter := self scripter.
	aScripter set model: [ self basicMethodCoder ].
	^ aScripter
]
