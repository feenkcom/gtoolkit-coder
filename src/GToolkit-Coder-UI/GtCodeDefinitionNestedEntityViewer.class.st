Class {
	#name : #GtCodeDefinitionNestedEntityViewer,
	#superclass : #GtCodeDefinitionViewer,
	#instVars : [
		'editor',
		'nestedEditors'
	],
	#category : #'GToolkit-Coder-UI-Behaviour - Editor / Reader'
}

{ #category : #'api - instantiation' }
GtCodeDefinitionNestedEntityViewer >> create [
	<return: #Object>
	| aContainer theNestedEditors |
	
	aContainer := BlElement new
		layout: (BlLinearLayout vertical);
		focusability: BlFocusability ignore;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ].

	aContainer addChild: (editor
		margin: margin;
		aptitude: lookStencil) asElement.
	
	theNestedEditors := BlElement new
		layout: (BlGridLayout new columnCount: 2);
		focusability: BlFocusability ignore;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ].

	self nestedEditors do: [ :eachEditor |
		theNestedEditors addChildren: { 
				(self buildSectionLabel: eachEditor title).
				(eachEditor
					aptitude: lookStencil;
					margin: margin;
					asElement) } ].

	aContainer addChild: theNestedEditors.

	^ aContainer
]

{ #category : #accessing }
GtCodeDefinitionNestedEntityViewer >> editor [
	^ editor
]

{ #category : #accessing }
GtCodeDefinitionNestedEntityViewer >> editor: anObject [
	editor := anObject.
	self title: editor title
]

{ #category : #accessing }
GtCodeDefinitionNestedEntityViewer >> nestedEditors [
	^ nestedEditors
]

{ #category : #accessing }
GtCodeDefinitionNestedEntityViewer >> nestedEditors: anObject [
	nestedEditors := anObject
]
