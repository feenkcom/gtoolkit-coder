Class {
	#name : #GtPackageCoderTool,
	#superclass : #GtCoderTool,
	#instVars : [
		'package'
	],
	#category : #'GToolkit-Coder-UI-Tools'
}

{ #category : #'instance creation' }
GtPackageCoderTool class >> forPackage: aPackage [
	^ self new package: aPackage
]

{ #category : #'instance creation' }
GtPackageCoderTool class >> package: aPackage [
	"Should be removed since it overrides core method."

	self deprecated: 'Use #forPackage: instead'.

	^ self forPackage: aPackage
]

{ #category : #converting }
GtPackageCoderTool >> newCoder [
	^ GtCoderElement forPackage: self package
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
