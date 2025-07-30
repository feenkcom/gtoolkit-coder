Class {
	#name : #GtCoderFilterListItemElement,
	#superclass : #BrHorizontalPane,
	#instVars : [
		'item',
		'labelElement'
	],
	#category : #'GToolkit-Coder-UI-Basic'
}

{ #category : #initialization }
GtCoderFilterListItemElement >> initialize [
	super initialize.
	
	self addChild: (labelElement := self newLabelElement) as: #label.
	
	self hMatchParent.
	self vFitContent.
]

{ #category : #accessing }
GtCoderFilterListItemElement >> item [
	^ item
]

{ #category : #accessing }
GtCoderFilterListItemElement >> item: anObject [
	item == anObject ifTrue: [ ^ self ].
	item := anObject.
	self onItemChanged.
]

{ #category : #'private - instance creation' }
GtCoderFilterListItemElement >> newLabelElement [
	^ BrLabel new
		aptitude: BrGlamorousLabelAptitude
]

{ #category : #'private - hooks' }
GtCoderFilterListItemElement >> onItemChanged [
	labelElement text: self item title
]
