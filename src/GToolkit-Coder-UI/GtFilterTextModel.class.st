Class {
	#name : #GtFilterTextModel,
	#superclass : #GtFilterModel,
	#instVars : [
		'text'
	],
	#category : #'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #accessing }
GtFilterTextModel >> filterViewModelClass [
	^ GtFilterTextViewModel
]

{ #category : #initialization }
GtFilterTextModel >> initialize [
	super initialize.
	text := BlText empty
]

{ #category : #accessing }
GtFilterTextModel >> notifyTextChanged [
	self
		announce: (GtFilterTextModelTextChanged new
				model: self;
				text: self text)
]

{ #category : #accessing }
GtFilterTextModel >> text [
	<return: #BlText>
	^ text
]

{ #category : #accessing }
GtFilterTextModel >> text: aText [
	| aNewText |
	aNewText := aText asRopedText.
	(self text equals: aNewText) ifTrue: [ ^ self ].
	
	text := aNewText.
	self notifyTextChanged.
]
