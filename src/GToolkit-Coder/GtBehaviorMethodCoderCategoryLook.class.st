Class {
	#name : #GtBehaviorMethodCoderCategoryLook,
	#superclass : #GtMethodCoderCategoryLook,
	#category : #'GToolkit-Coder-Looks'
}

{ #category : #initialization }
GtBehaviorMethodCoderCategoryLook >> addCategoryToggle [
	self widget
		childNamed: #header
		ifFound: [ :header | header visibility: BlVisibility gone ]
		ifNone: [  ].
	self widget
		addChild: self buildCategoryToggle
		as: self categoryToggleName
]

{ #category : #initialization }
GtBehaviorMethodCoderCategoryLook >> removeCategoryToggle [
	super removeCategoryToggle.
	self widget
		childNamed: #header
		ifFound: [ :header | header visibility: BlVisibility visible ]
		ifNone: [  ]
]
