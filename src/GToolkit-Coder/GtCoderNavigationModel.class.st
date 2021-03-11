Class {
	#name : #GtCoderNavigationModel,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Navigation - Model'
}

{ #category : #factory }
GtCoderNavigationModel class >> default [
	^ GtCoderNavigationPackagesTagsClassesModel new
]

{ #category : #factory }
GtCoderNavigationModel class >> null [
	^ GtCoderNullNavigationModel default
]

{ #category : #'api - accessing' }
GtCoderNavigationModel >> classesToShow [
	<return: #Collection of: #Class>
	^ self subclassResponsibility
]

{ #category : #'api - accessing' }
GtCoderNavigationModel >> coderDo: aBlock [
	self subclassResponsibility
]

{ #category : #'api - testing' }
GtCoderNavigationModel >> hasSelectedClass [
	<return: #Boolean>
	^ self subclassResponsibility
]

{ #category : #'api - testing' }
GtCoderNavigationModel >> hasSelectedPackage [
	<return: #Boolean>
	^ self subclassResponsibility
]

{ #category : #'api - testing' }
GtCoderNavigationModel >> hasSelectedTag [
	<return: #Boolean>
	^ self subclassResponsibility
]

{ #category : #'api - testing' }
GtCoderNavigationModel >> isNavigationModel [
	^ true
]

{ #category : #'api - accessing' }
GtCoderNavigationModel >> packagesToShow [
	<return: #Collection of: #RPackage>
	^ self subclassResponsibility
]

{ #category : #'api - selection' }
GtCoderNavigationModel >> selectClass: aClass [
	self subclassResponsibility
]

{ #category : #'api - selection' }
GtCoderNavigationModel >> selectMethod: aCompiledMethod [
	self subclassResponsibility
]

{ #category : #'api - selection' }
GtCoderNavigationModel >> selectPackage: aPackage [
	self subclassResponsibility
]

{ #category : #'api - selection' }
GtCoderNavigationModel >> selectedClassDo: aBlock [
	self subclassResponsibility
]

{ #category : #'api - selection' }
GtCoderNavigationModel >> selectedPackageDo: aBlock [
	self subclassResponsibility
]

{ #category : #'api - selection' }
GtCoderNavigationModel >> selectedTagDo: aBlock [
	self subclassResponsibility
]

{ #category : #'api - subscriptions' }
GtCoderNavigationModel >> subscribeToSystem [
	"concrete models can subscribe to the system"
]

{ #category : #'api - subscriptions' }
GtCoderNavigationModel >> unsubscribeFromSystem [
	"concrete models can unsubscribe from the system"
]
