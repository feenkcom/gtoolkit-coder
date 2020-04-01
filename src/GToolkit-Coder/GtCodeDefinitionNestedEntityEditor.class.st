Class {
	#name : #GtCodeDefinitionNestedEntityEditor,
	#superclass : #GtCodeDefinitionEditor,
	#instVars : [
		'editor',
		'nestedEditors'
	],
	#category : #'GToolkit-Coder-Behavior - Editors'
}

{ #category : #'api - instantiation' }
GtCodeDefinitionNestedEntityEditor >> create [
	<return: #Object>
	| aContainer theNestedEditors |
	
	aContainer := BlElement new
		layout: (BlLinearLayout vertical);
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ].

	aContainer addChild: (editor
		margin: margin;
		look: lookStencil) asElement.
	
	theNestedEditors := BlElement new
		layout: (BlGridLayout new columnCount: 2);
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ].

	self nestedEditors do: [ :eachEditor |
		theNestedEditors addChildren: { 
				(self buildSectionLabel: eachEditor title).
				(eachEditor
					look: lookStencil;
					margin: margin;
					asElement) } ].

	aContainer addChild: theNestedEditors.

	^ aContainer
]

{ #category : #accessing }
GtCodeDefinitionNestedEntityEditor >> editor [
	^ editor
]

{ #category : #accessing }
GtCodeDefinitionNestedEntityEditor >> editor: anObject [
	editor := anObject.
	self title: editor title
]

{ #category : #accessing }
GtCodeDefinitionNestedEntityEditor >> nestedEditors [
	^ nestedEditors
]

{ #category : #accessing }
GtCodeDefinitionNestedEntityEditor >> nestedEditors: anObject [
	nestedEditors := anObject
]
