Class {
	#name : #GtPackageTagCardElement,
	#superclass : #GtCoderCardElement,
	#category : #'GToolkit-Coder-UIOld'
}

{ #category : #'building ui' }
GtPackageTagCardElement >> detailsLabel [
	^ coder packageTag classes size printString , ' Classes'
]
