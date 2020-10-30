Class {
	#name : #GtMethodCoderCategoryLook,
	#superclass : #GtSourceCoderLook,
	#instVars : [
		'tags'
	],
	#category : #'GToolkit-Coder-UI-Coder - Method'
}

{ #category : #initialization }
GtMethodCoderCategoryLook >> initialize [
	super initialize.

	tags := self newTagsElement.

	self addChangeAddChildAs: #(content tags) with: [ tags ]
]

{ #category : #'instance creation' }
GtMethodCoderCategoryLook >> newTagsElement [
	^ self newTagsElementClass new
		constraintsDo: [ :c | 
			c ignoreByLayout.
			c ignored horizontal alignRight.
			c ignored vertical alignBottom ];
		zIndex: 10
]

{ #category : #'instance creation' }
GtMethodCoderCategoryLook >> newTagsElementClass [
	^ GtMethodCoderTagsElement
]

{ #category : #hooks }
GtMethodCoderCategoryLook >> onCoderChanged: aGtSourceCoderUIModel [
	tags coder: aGtSourceCoderUIModel coder
]
