Class {
	#name : #GtCodeDiffBuilder,
	#superclass : #TextDiffBuilder,
	#instVars : [
		'isMethod'
	],
	#category : #'GToolkit-Coder-UI-Diff'
}

{ #category : #initialization }
GtCodeDiffBuilder >> initialize [
	super initialize.
	isMethod := true
]

{ #category : #accessing }
GtCodeDiffBuilder >> isMethod [
	^ isMethod
]

{ #category : #accessing }
GtCodeDiffBuilder >> isMethod: aBoolean [
	isMethod := aBoolean
]

{ #category : #'instance creation' }
GtCodeDiffBuilder >> newStyler [
	^ GtCodeDiffRBTextStyler new
		isForWorkspace: isMethod not;
		yourself
]
