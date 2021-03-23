Class {
	#name : #GtPharoDeprecationStyler,
	#superclass : #GtGenericPharoStyler,
	#category : #'GToolkit-Coder-Pharo-AddOns-Deprecation'
}

{ #category : #generated }
GtPharoDeprecationStyler >> visitNamedVariable: aNamedVariable [
	super visitNamedVariable: aNamedVariable.
	
	(self coderViewModel isDeprecatedGlobalNamed: aNamedVariable variableName)
		ifFalse: [ ^ self ].
	
	self
		attribute: (BlTextDecorationAttribute new lineThrough color: Color blue muchDarker)
		from: aNamedVariable name startPosition
		to: aNamedVariable name stopPosition
]
