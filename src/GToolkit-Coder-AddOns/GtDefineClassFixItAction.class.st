Class {
	#name : #GtDefineClassFixItAction,
	#superclass : #GtFixItAction,
	#category : #'GToolkit-Coder-AddOns-FixIt'
}

{ #category : #private }
GtDefineClassFixItAction >> addCreateClassAttribute [
	sourceCoder
		sourceTextDo: [ :text | 
			| stencilBlock attribute adornmentAttribute |
			stencilBlock := [ | element |
			element := GtCreateBehaviorElement new.
			element
				behaviorBlock: [ :cls | 
					text
						clearAttributes: [ :each | each == attribute or: [ each == adornmentAttribute ] ].
					sourceCoder requestStyleSourceText ].
			element forClassDefinition.
			element forClassName: node name asSymbol.
			sourceCoder package
				ifNotNil: [ :package | element forPackage: package ].
			sourceCoder packageTag
				ifNotNil: [ :tag | element forPackageTag: tag ].
			element addLook: BrShadowLook.
			element background: Color white.
			element margin: (BlInsets all: 10).
			element
				constraintsDo: [ :c | 
					c textFlow pushLine.
					c horizontal matchParent ].
			element ].
			attribute := BrTextExpandButtonAttribute new.
			attribute isExpanded: true.
			attribute
				attributesCreatingBlock: [ adornmentAttribute := BrTextAdornmentDynamicAttribute new
						beAppend;
						stencil: stencilBlock ].
			(text from: node stop to: node stop) attributes: {attribute} ]
]

{ #category : #accessing }
GtDefineClassFixItAction >> description [
	^ 'Create class ' , node name
]

{ #category : #accessing }
GtDefineClassFixItAction >> execute [
	self clearFixItAttribute.
	self addCreateClassAttribute
]
