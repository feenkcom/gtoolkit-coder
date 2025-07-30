Class {
	#name : #GtPackageCardElement,
	#superclass : #GtCoderCardElement,
	#category : #'GToolkit-Coder-UI-Basic'
}

{ #category : #'building ui' }
GtPackageCardElement >> detailsLabel [
	| extensionMethodsCount |
	extensionMethodsCount := self extensionMethodsCount.
	^ coder package definedClasses size printString , ' Classes'
	  , (extensionMethodsCount > 0
			   ifTrue: [ 
			   ', ' , extensionMethodsCount printString , ' Extension methods' ]
			   ifFalse: [ '' ])
]

{ #category : #'building ui' }
GtPackageCardElement >> extensionMethodsCount [
	| count |
	count := 0.
	coder package extendedClasses do: [ :each | 
		count := count
		         + (coder package extensionSelectorsForClass: each) size ].
	^ count
]
