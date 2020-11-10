Class {
	#name : #GtSearchMethodsInInstanceAndClassSideFilter,
	#superclass : #GtSearchMethodsContainedInClassFilter,
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #testing }
GtSearchMethodsInInstanceAndClassSideFilter >> includesMethod: aCompiledMethod [
	| methodClass |
	methodClass := aCompiledMethod methodClass.
	^ (methodClass = class instanceSide) or: [ 
		methodClass = class classSide ]
]

{ #category : #enumerating }
GtSearchMethodsInInstanceAndClassSideFilter >> methodsDo: aBlock [
	class instanceSide methods do: aBlock.

	"#methods includes ones from TraitedClass"
	class classSide visibleMethods do: aBlock
]
