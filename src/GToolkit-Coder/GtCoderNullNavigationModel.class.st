Class {
	#name : #GtCoderNullNavigationModel,
	#superclass : #GtCoderNavigationModel,
	#traits : 'TGtUniqueInstance',
	#classTraits : 'TGtUniqueInstance classTrait',
	#category : #'GToolkit-Coder-Navigation - Model'
}

{ #category : #'api - accessing' }
GtCoderNullNavigationModel >> classesToShow [
	^ #()
]

{ #category : #'api - accessing' }
GtCoderNullNavigationModel >> coderDo: aBlock [
	"do nothing"
]

{ #category : #'api - testing' }
GtCoderNullNavigationModel >> hasSelectedClass [
	^ false
]

{ #category : #'api - testing' }
GtCoderNullNavigationModel >> hasSelectedPackage [
	^ false
]

{ #category : #'api - testing' }
GtCoderNullNavigationModel >> hasSelectedTag [
	^ false
]

{ #category : #'api - testing' }
GtCoderNullNavigationModel >> isNavigationModel [
	^ false
]

{ #category : #'api - accessing' }
GtCoderNullNavigationModel >> packagesToShow [
	^ #()
]

{ #category : #'api - selection' }
GtCoderNullNavigationModel >> selectClass: aClass [
	"do nothing"
]

{ #category : #'api - selection' }
GtCoderNullNavigationModel >> selectMethod: aCompiledMethod [
	"do nothing"
]

{ #category : #'api - selection' }
GtCoderNullNavigationModel >> selectMethodProtocol: aMethodProtocol [
	"do nothing"
]

{ #category : #'api - selection' }
GtCoderNullNavigationModel >> selectPackage: aPackage [
	"do nothing"
]

{ #category : #'api - selection' }
GtCoderNullNavigationModel >> selectedClassDo: aBlock [
	"do nothing"
]

{ #category : #'api - selection' }
GtCoderNullNavigationModel >> selectedPackageDo: aBlock [
	"do nothing"
]

{ #category : #'api - selection' }
GtCoderNullNavigationModel >> selectedTagDo: aBlock [
	"do nothing"
]
