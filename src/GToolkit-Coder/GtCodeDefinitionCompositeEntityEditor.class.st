Class {
	#name : #GtCodeDefinitionCompositeEntityEditor,
	#superclass : #GtCodeDefinitionEditor,
	#instVars : [
		'editors',
		'separatorStencil',
		'showSectionNames'
	],
	#category : #'GToolkit-Coder-Behavior - Editors'
}

{ #category : #'instance creation' }
GtCodeDefinitionCompositeEntityEditor class >> withAll: aCollectionOfEditors [
	^ self new editors: aCollectionOfEditors
]

{ #category : #'api - instantiation' }
GtCodeDefinitionCompositeEntityEditor >> create [
	<return: #Object>

	^ BlElement new
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		focusability: BlFocusability ignore;
		addChildren: (Array streamContents: [ :aStream |
			| aCurrentIndex |
			aCurrentIndex := 1.
				editors
					do: [ :eachEditor |
						aCurrentIndex := aCurrentIndex + 1.
						eachEditor
							margin: margin;
							look: lookStencil.
						aStream nextPut: (eachEditor asElement) ]
					separatedBy: [
						separatorStencil ifNotNil: [ :aStencil |
							aStream nextPut: (aStencil asElement
								focusability: BlFocusability none;
								margin: (BlInsets left: ((4 - self margin right) max: 0) right: ((4 - self margin left) max: 0));
								constraintsDo: [ :c | c flow vertical alignCenter ]) ].
						
						showSectionNames ifTrue: [
							aStream nextPut: (self buildSectionLabel: (editors at: aCurrentIndex) title) ] ] ])
]

{ #category : #accessing }
GtCodeDefinitionCompositeEntityEditor >> editors [
	^ editors
]

{ #category : #accessing }
GtCodeDefinitionCompositeEntityEditor >> editors: anObject [
	editors := anObject.
	self title: editors first title
]

{ #category : #initialization }
GtCodeDefinitionCompositeEntityEditor >> initialize [
	super initialize.
	
	separatorStencil := nil.
	showSectionNames := true
]

{ #category : #accessing }
GtCodeDefinitionCompositeEntityEditor >> separator: aStencil [
	separatorStencil := aStencil asStencil
]

{ #category : #accessing }
GtCodeDefinitionCompositeEntityEditor >> withSectionNames [
	showSectionNames := true
]

{ #category : #accessing }
GtCodeDefinitionCompositeEntityEditor >> withoutSectionNames [
	showSectionNames := false
]
