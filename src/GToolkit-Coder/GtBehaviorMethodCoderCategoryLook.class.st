Class {
	#name : #GtBehaviorMethodCoderCategoryLook,
	#superclass : #GtMethodCoderCategoryLook,
	#category : #'GToolkit-Coder-Looks'
}

{ #category : #initialization }
GtBehaviorMethodCoderCategoryLook >> addCategoryEditor [
	self widget
		childNamed: #header
		ifFound: [ :header | header visibility: BlVisibility gone ]
		ifNone: [  ].
	self widget
		addChild: self buildCategoryEditor
		as: self categoryEditorName
]

{ #category : #initialization }
GtBehaviorMethodCoderCategoryLook >> removeCategoryEditor [
	super removeCategoryEditor.
	self widget
		childNamed: #header
		ifFound: [ :header | header visibility: BlVisibility visible ]
		ifNone: [  ]
]
