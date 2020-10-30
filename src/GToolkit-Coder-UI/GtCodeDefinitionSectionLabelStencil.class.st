Class {
	#name : #GtCodeDefinitionSectionLabelStencil,
	#superclass : #BrStencil,
	#instVars : [
		'name'
	],
	#category : #'GToolkit-Coder-UI-Behaviour - Editor / Reader'
}

{ #category : #'api - instantiation' }
GtCodeDefinitionSectionLabelStencil >> create [
	<return: #Object>

	^ BrLabel new
		look: (BrGlamorousLabelLook new glamorousRegularFontAndSize foreground: Color gray; fontSize: 12);
		text: self name;
		margin: (BlInsets top: 5 right: 2);
		constraintsDo: [ :c | c grid horizontal alignLeft ]
]

{ #category : #accessing }
GtCodeDefinitionSectionLabelStencil >> name [
	^ name
]

{ #category : #accessing }
GtCodeDefinitionSectionLabelStencil >> name: anObject [
	name := anObject
]
