Class {
	#name : #GtCoderPackageTagClassNavigationModel,
	#superclass : #Object,
	#instVars : [
		'selectedPackage',
		'selectedClass'
	],
	#category : #'GToolkit-Coder-Navigation'
}

{ #category : #testing }
GtCoderPackageTagClassNavigationModel >> hasSelectedClass [
	<return: #Boolean>

	^ selectedClass isNotNil
]

{ #category : #testing }
GtCoderPackageTagClassNavigationModel >> hasSelectedPackage [
	<return: #Boolean>

	^ selectedPackage isNotNil
]

{ #category : #'api - accessing' }
GtCoderPackageTagClassNavigationModel >> selectedClass [
	<return: #Class>
	self
		assert: [ self hasSelectedClass ]
		description: [ 'A class must be selected' ].
		
	^ selectedClass
]

{ #category : #'api - accessing' }
GtCoderPackageTagClassNavigationModel >> selectedClassDo: aBlock [
	self hasSelectedClass
		ifTrue: [ aBlock value: self selectedClass ]
]

{ #category : #'api - accessing' }
GtCoderPackageTagClassNavigationModel >> selectedPackage [
	<return: #RPackage>
	self
		assert: [ self hasSelectedPackage ]
		description: [ 'A package must be selected' ].
		
	^ selectedPackage
]

{ #category : #'api - accessing' }
GtCoderPackageTagClassNavigationModel >> selectedPackageDo: aBlock [
	self hasSelectedPackage
		ifTrue: [ aBlock value: self selectedPackage ]
]
