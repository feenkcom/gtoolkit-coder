Class {
	#name : #GtGenericPharoStyler,
	#superclass : #GtCoderAstStyler,
	#traits : 'TGtPharoProgramNodeVisitor',
	#classTraits : 'TGtPharoProgramNodeVisitor classTrait',
	#category : #'GToolkit-Coder-Pharo-Styler'
}

{ #category : #'api - styling' }
GtGenericPharoStyler >> style: aText ast: theAst [
	text := aText.
	[ self accept: theAst ]
		ensure: [ text := nil ]
]
