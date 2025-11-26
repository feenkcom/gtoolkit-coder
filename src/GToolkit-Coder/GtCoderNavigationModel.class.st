Class {
	#name : #GtCoderNavigationModel,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Navigation - Model'
}

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
GtCoderNavigationModel >> hasSelectedPackageOrClass [
	<return: #Boolean>
	^ self hasSelectedPackage or: [ self hasSelectedClass ]
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
	<return: #Collection of: #Package>
	^ self subclassResponsibility
]

{ #category : #'api - selection' }
GtCoderNavigationModel >> selectClass: aClass [
	self subclassResponsibility
]

{ #category : #'api - selection' }
GtCoderNavigationModel >> selectClasses: aCollectionOfClasses [
	self subclassResponsibility
]

{ #category : #'api - selection' }
GtCoderNavigationModel >> selectMethod: aMethod [
	self selectMethod: aMethod source: self
]

{ #category : #'api - selection' }
GtCoderNavigationModel >> selectMethod: aCompiledMethod source: aSource [
	self subclassResponsibility
]

{ #category : #'api - selection' }
GtCoderNavigationModel >> selectMethods: aCollectionOfMethods [
	self selectMethods: aCollectionOfMethods source: self
]

{ #category : #'api - selection' }
GtCoderNavigationModel >> selectMethods: aCollectionOfCompiledMethods source: aSource [
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
GtCoderNavigationModel >> selectedMethod: aCompiledMethod source: aSource [
	"Inform that another method was selected and should be reflected in the navigation model."

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
