Class {
	#name : #GtFilterTextModel,
	#superclass : #GtFilterModel,
	#instVars : [
		'text',
		'inputFilter',
		'completionBuilder'
	],
	#category : #'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #accessing }
GtFilterTextModel >> completion [
	<return: #GtCompletionStrategy or: nil>
	^ completionBuilder value
]

{ #category : #accessing }
GtFilterTextModel >> completion: aCompletionBuilder [
	completionBuilder := aCompletionBuilder
]

{ #category : #accessing }
GtFilterTextModel >> completionDo: aBlock [
	self completion ifNotNil: aBlock
]

{ #category : #accessing }
GtFilterTextModel >> filterViewModelClass [
	^ GtFilterTextViewModel
]

{ #category : #initialization }
GtFilterTextModel >> initialize [
	super initialize.
	text := BlText empty.
	inputFilter := BrTextEditorNoLineBreakInputFilter new.
]

{ #category : #accessing }
GtFilterTextModel >> inputFilter [
	<return: #BrTextEditorInputFilter>
	^ inputFilter
]

{ #category : #accessing }
GtFilterTextModel >> inputFilter: anInputFilter [
	inputFilter = anInputFilter ifTrue: [ ^ self ].
	
	inputFilter := anInputFilter.
	self notifyInputFilterChanged.
]

{ #category : #'private - notifying' }
GtFilterTextModel >> notifyInputFilterChanged [
	self
		announce: (GtFilterTextModelInputFilterChanged new
				model: self;
				inputFilter: self inputFilter)
]

{ #category : #'private - notifying' }
GtFilterTextModel >> notifyTextChanged [
	self
		announce: (GtFilterTextModelTextChanged new
				model: self;
				text: self text)
]

{ #category : #accessing }
GtFilterTextModel >> selectedValue [
	"Return a filter value, e.g., selected item, input text."

	^ self text asString
]

{ #category : #accessing }
GtFilterTextModel >> text [
	<return: #BlText>
	^ text
]

{ #category : #accessing }
GtFilterTextModel >> text: aText [
	| aNewText |
	aText ifNil: [ ^ self ].
	aNewText := aText asRopedText.
	(self text equals: aNewText) ifTrue: [ ^ self ].
	
	text := aNewText.
	self notifyTextChanged.
]
