Class {
	#name : #GtCoderNavigationPackagesTagsClassesElementExamples,
	#superclass : #GtCoderNavigationElementExamples,
	#category : #'GToolkit-Coder-Examples-Navigation'
}

{ #category : #asserting }
GtCoderNavigationPackagesTagsClassesElementExamples >> assertSelectionOfPackage: aRPackage tag: aRPackageTag class: aClass inElement: anElement [

	self assert: anElement selectedPackage equals: aRPackage.
	self assert: anElement selectedPackageTag equals: aRPackageTag.
	self assert: anElement selectedClass equals: aClass.
]

{ #category : #'examples - basic' }
GtCoderNavigationPackagesTagsClassesElementExamples >> basicElement [
	<gtExample>
	| anElement |
	anElement := GtCoderNavigationPackagesTagsClassesElement new.
	self assert: anElement navigationModel isNil.
	^ anElement
]

{ #category : #'examples - system items' }
GtCoderNavigationPackagesTagsClassesElementExamples >> classInPackage [
	<gtExample>
	^ BaselineOfGToolkitCoder
]

{ #category : #'examples - system items' }
GtCoderNavigationPackagesTagsClassesElementExamples >> classInPackageTag [
	<gtExample>
	^ self class
]

{ #category : #'examples - basic' }
GtCoderNavigationPackagesTagsClassesElementExamples >> elementNavigationModel [
	<gtExample>
	| anElement aModel |
	anElement := self basicElement.
	aModel := self basicPackageTagsClassesNavigation.
	anElement navigationModel: aModel.
	self assert: anElement navigationModel equals: aModel.
	self assert: anElement navigationModel announcer numberOfSubscriptions equals: 0.
	self assertSelectionOfPackage: nil tag: nil class: nil inElement: anElement.
	^ anElement
]

{ #category : #'examples - basic' }
GtCoderNavigationPackagesTagsClassesElementExamples >> elementNavigationModelInSpace [
	<gtExample>
	| anElement |
	anElement := self elementNavigationModel.
	self putInSpace: anElement.
	self assert: anElement navigationModel announcer numberOfSubscriptions equals: 9.
	self assertSelectionOfPackage: nil tag: nil class: nil inElement: anElement.
	^ anElement
]

{ #category : #'examples - class selection' }
GtCoderNavigationPackagesTagsClassesElementExamples >> elementWithPackageAndClassSelection [
	<gtExample>
	| anElement |
	anElement := self elementNavigationModelInSpace.
	anElement navigationModel selectClass: self classInPackage.
	self 
		assertSelectionOfPackage: self classInPackage package
		tag: nil 
		class: self classInPackage 
		inElement: anElement.
	^ anElement
]

{ #category : #'examples - class selection' }
GtCoderNavigationPackagesTagsClassesElementExamples >> elementWithPackageTagAndClassSelection [
	<gtExample>
	| anElement |
	anElement := self elementNavigationModelInSpace.
	anElement navigationModel selectClass: self classInPackageTag.
	self 
		assertSelectionOfPackage: nil
		tag: self packageTag 
		class: self classInPackageTag 
		inElement: anElement.
	^ anElement
]

{ #category : #'examples - package tag selection' }
GtCoderNavigationPackagesTagsClassesElementExamples >> elementWithPackageTagSelection [
	<gtExample>
	| anElement |
	anElement := self elementNavigationModelInSpace.
	anElement navigationModel selectPackageTag: self packageTag.
	self 
		assertSelectionOfPackage: nil
		tag: self packageTag 
		class: nil 
		inElement: anElement.
	^ anElement
]

{ #category : #'examples - package selection' }
GtCoderNavigationPackagesTagsClassesElementExamples >> elementWithPackageWithoutTagsAndExtensionsSelection [
	<gtExample>
	| anElement |
	anElement := self elementNavigationModelInSpace.
	anElement navigationModel selectPackage: self packageWithoutTagsAndExtensions.
	self 
		assertSelectionOfPackage: self packageWithoutTagsAndExtensions 
		tag: nil 
		class: nil 
		inElement: anElement.
	^ anElement
]

{ #category : #'examples - package selection' }
GtCoderNavigationPackagesTagsClassesElementExamples >> elementWithPackageWithoutTagsAndExtensionsSelection_Children [
	<gtExample>
	| anElement aPackageNode |
	anElement := self elementWithPackageWithoutTagsAndExtensionsSelection.
	aPackageNode := anElement selectedPackageNodeDo: [ :aNode | aNode ].
	self assert: aPackageNode isNotNil.
	self assert: aPackageNode children size equals: 0.
	^ anElement
]

{ #category : #'examples - system items' }
GtCoderNavigationPackagesTagsClassesElementExamples >> packageTag [
	<gtExample>
	^ self packageWithTagsAndWithoutExtensions classTagNamed: 'Navigation'
]

{ #category : #'examples - system items' }
GtCoderNavigationPackagesTagsClassesElementExamples >> packageWithTagsAndWithoutExtensions [
	<gtExample>
	^ 'GToolkit-Coder-Examples' asPackage 
]

{ #category : #'examples - system items' }
GtCoderNavigationPackagesTagsClassesElementExamples >> packageWithoutTagsAndExtensions [
	<gtExample>
	^ 'GToolkit-Coder-Examples-SystemS1' asPackage 
]
