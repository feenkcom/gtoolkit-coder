Class {
	#name : #GtCodeDefinitionCompositeEntityEditor,
	#superclass : #GtCodeDefinitionEditor,
	#instVars : [
		'editors'
	],
	#category : #'GToolkit-Coder-Behavior - Model'
}

{ #category : #'instance creation' }
GtCodeDefinitionCompositeEntityEditor class >> withAll: aCollectionOfEditors [
	^ self new editors: aCollectionOfEditors
]

{ #category : #'api - instantiation' }
GtCodeDefinitionCompositeEntityEditor >> create [
	<return: #Object>

	^ BlElement new
		layout: BlFlowLayout horizontal;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		addChildren: (Array streamContents: [ :aStream |
				editors
					do: [ :eachEditor |
						eachEditor
							margin: margin;
							look: lookStencil.
						aStream nextPut: (eachEditor asElement) ]
					separatedBy: [ aStream nextPut: (BrLabel new
						look: (BrGlamorousLabelLook new glamorousCodeFontAndSize foreground: BrGlamorousColors darkBorderColor);
						text: '/';
						margin: (BlInsets left: ((4 - self margin right) max: 0) right: ((4 - self margin left) max: 0));
						constraintsDo: [ :c | c flow vertical alignCenter ]) ]])
]

{ #category : #accessing }
GtCodeDefinitionCompositeEntityEditor >> editors [
	^ editors
]

{ #category : #accessing }
GtCodeDefinitionCompositeEntityEditor >> editors: anObject [
	editors := anObject
]
