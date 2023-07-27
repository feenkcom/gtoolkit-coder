Class {
	#name : #GtPackageTagCoderTool,
	#superclass : #GtCoderTool,
	#instVars : [
		'packageTag'
	],
	#category : #'GToolkit-Coder-UI-Tools'
}

{ #category : #'instace creation' }
GtPackageTagCoderTool class >> packageTag: aPackageTag [
	^ self new packageTag: aPackageTag
]

{ #category : #accessing }
GtPackageTagCoderTool >> newCoder [
	^ GtCoderElement forPackageTag: self packageTag
]

{ #category : #accessing }
GtPackageTagCoderTool >> packageTag [
	^ packageTag
]

{ #category : #accessing }
GtPackageTagCoderTool >> packageTag: aPackageTag [
	packageTag := aPackageTag
]
