Class {
	#name : #GtPackageTagCardElement,
	#superclass : #GtCoderCardElement,
	#category : #'GToolkit-Coder-UI-Basic'
}

{ #category : #'building ui' }
GtPackageTagCardElement >> detailsLabel [
	^ coder packageTag classes size printString , ' Classes'
]
