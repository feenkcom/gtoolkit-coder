Class {
	#name : #GtPackageTagCoderTool,
	#superclass : #GtCoderTool,
	#instVars : [
		'packageTag'
	],
	#category : 'GToolkit-Coder-UI-Tools'
}

{ #category : #'instace creation' }
GtPackageTagCoderTool class >> forPackageTag: aPackageTag [
	^ self new packageTag: aPackageTag
]

{ #category : #'instace creation' }
GtPackageTagCoderTool class >> packageTag: aPackageTag [
	"Should be removed since it overrides core method."

	self deprecated: 'Use #forPackageTag: instead'.
	
	^ self forPackageTag: aPackageTag
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
