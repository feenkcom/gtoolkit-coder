Class {
	#name : #GtExpandableMethodCoderElement,
	#superclass : #GtExpandableSourceCoderElement,
	#instVars : [
		'tagsElement'
	],
	#category : #'GToolkit-Coder-UI-Coder - Method'
}

{ #category : #private }
GtExpandableMethodCoderElement >> alignTagsElementBottomRight: aTagsElement [
	aTagsElement
		constraintsDo: [ :c |
			c ignored horizontal alignRight.
			c ignored vertical alignBottom ]
]

{ #category : #private }
GtExpandableMethodCoderElement >> alignTagsElementCenterRight: aTagsElement [
	aTagsElement
		constraintsDo: [ :c |
			c ignored horizontal alignRight.
			c ignored vertical alignCenter ]
]

{ #category : #accessing }
GtExpandableMethodCoderElement >> coderUIModel: aCoderUIModel [
	super coderUIModel: aCoderUIModel.
	
	tagsElement methodCoderUIModel: aCoderUIModel
]

{ #category : #initialization }
GtExpandableMethodCoderElement >> initialize [
	super initialize.
	
	tagsElement := self newTagsElement.
	self addChild: tagsElement
]

{ #category : #'private - instance creation' }
GtExpandableMethodCoderElement >> newTagsElement [
	^ self newTagsElementClass new
		constraintsDo: [ :c | 
			c ignoreByLayout.
			c ignored horizontal alignRight.
			c ignored vertical alignBottom.
			c margin: (BlInsets top: 5 left: 5 bottom: 5 right: 5) ];
		zIndex: 10
]

{ #category : #'private - instance creation' }
GtExpandableMethodCoderElement >> newTagsElementClass [
	^ GtMethodCoderTagsElement
]

{ #category : #private }
GtExpandableMethodCoderElement >> onCollapsed [
	super onCollapsed.
		
	self alignTagsElementCenterRight: tagsElement
]

{ #category : #private }
GtExpandableMethodCoderElement >> onExpanded [
	super onExpanded.
		
	self alignTagsElementBottomRight: tagsElement
]
