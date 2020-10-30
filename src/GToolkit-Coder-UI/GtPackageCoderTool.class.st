Class {
	#name : #GtPackageCoderTool,
	#superclass : #GtCoderTool,
	#instVars : [
		'package'
	],
	#category : #'GToolkit-Coder-UI-Tools'
}

{ #category : #'instance creation' }
GtPackageCoderTool class >> package: aPackage [
	^ self new package: aPackage
]

{ #category : #converting }
GtPackageCoderTool >> newCoder [
	^ GtCoder forPackage: self package
]

{ #category : #accessing }
GtPackageCoderTool >> object [
	"compatibility method for ${GLMBlocObjectToSelect}$"
	^ self package
]

{ #category : #accessing }
GtPackageCoderTool >> package [
	^ package
]

{ #category : #accessing }
GtPackageCoderTool >> package: aPackage [
	package := aPackage
]
