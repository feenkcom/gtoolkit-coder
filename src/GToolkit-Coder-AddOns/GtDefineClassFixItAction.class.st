Class {
	#name : 'GtDefineClassFixItAction',
	#superclass : 'GtFixItVariableNodeAction',
	#category : 'GToolkit-Coder-AddOns-FixIt'
}

{ #category : 'private' }
GtDefineClassFixItAction >> addCreateClassAttributeInEditor: aBrTextEditor [
	| text stencilBlock attribute adornmentAttribute | 
	
	text := aBrTextEditor text.
	stencilBlock := [ | element |
	element := GtPharoCreateBehaviorElement new.
	element
		behaviorBlock: [ :cls | 
			text
				clearAttributes: [ :each | each == attribute or: [ each == adornmentAttribute ] ].
			sourceCoder requestStyleSourceText ].
	element forClassDefinition.
	element forClassName: node name value asSymbol.
	sourceCoder package
		ifNotNil: [ :package | element forPackage: package ].
	sourceCoder packageTag
		ifNotNil: [ :tag | element forPackageTag: tag ].
	element addAptitude: BrShadowAptitude.
	element background: Color white.
	element margin: (BlInsets all: 10).
	element
		constraintsDo: [ :c | 
			c textFlow pushLine.
			c horizontal matchParent ].
	element ].
	attribute := BrGlamorousTrangleExpanderTextAttribute new.
	attribute isExpanded: true.
	attribute
		attributesCreatingBlock: [ adornmentAttribute := BrTextAdornmentDynamicAttribute new
				beAppend;
				stencil: stencilBlock ].
	text
		attribute: attribute
		from: self attributePosition
		to: self attributePosition
]

{ #category : 'accessing' }
GtDefineClassFixItAction >> description [
	^ 'Create class ' , self nodeName
]

{ #category : 'accessing' }
GtDefineClassFixItAction >> executeOn: anEditorElement [
	self clearFixItAttributeInEditor: anEditorElement editor.
	self addCreateClassAttributeInEditor: anEditorElement editor.
]

{ #category : 'accessing' }
GtDefineClassFixItAction >> id [
	<return: #BlElementId>

	^ GtDefineClassFixItActionElementId
]
