Class {
	#name : #GtPackageTagCardElement,
	#superclass : #GtCoderCardElement,
	#category : #'GToolkit-Coder-UI'
}

{ #category : #'building ui' }
GtPackageTagCardElement >> detailsLabel [
	^ coder packageTag classes size printString , ' Classes'
]
