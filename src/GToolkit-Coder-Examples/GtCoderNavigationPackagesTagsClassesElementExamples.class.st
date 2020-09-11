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

{ #category : #'examples - system items' }
GtCoderNavigationPackagesTagsClassesElementExamples >> classInUncategorizedPackageTag [
	<gtExample>
	^ GtCoderUncategorizedDummyClass
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
	self assert: anElement navigationModel announcer numberOfSubscriptions equals: self numberOfSubscriptions.
	self assertSelectionOfPackage: nil tag: nil class: nil inElement: anElement.
	^ anElement
]

{ #category : #'examples - class selection' }
GtCoderNavigationPackagesTagsClassesElementExamples >> elementWithPackageAndClassSelection [
	<noTest>
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
GtCoderNavigationPackagesTagsClassesElementExamples >> elementWithPackageAndClassSelection_BeforeInSpace [
	<noTest>
	<gtExample>
	| anElement |
	anElement := self elementNavigationModel.
	anElement navigationModel selectClass: self classInPackage.
	self putInSpace: anElement.
	self 
		assertSelectionOfPackage: self classInPackage package
		tag: nil 
		class: self classInPackage 
		inElement: anElement.
	^ anElement
]

{ #category : #'examples - class selection' }
GtCoderNavigationPackagesTagsClassesElementExamples >> elementWithPackageTagAndClassSelection [
	<noTest>
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

{ #category : #'examples - class selection' }
GtCoderNavigationPackagesTagsClassesElementExamples >> elementWithPackageTagAndClassSelection_BeforeInSpace [
	<noTest>
	<gtExample>
	| anElement |
	anElement := self elementNavigationModel.
	anElement navigationModel selectClass: self classInPackageTag.
	self putInSpace: anElement.
	self 
		assertSelectionOfPackage: nil
		tag: self packageTag 
		class: self classInPackageTag 
		inElement: anElement.
	^ anElement
]

{ #category : #'examples - package tag selection' }
GtCoderNavigationPackagesTagsClassesElementExamples >> elementWithPackageTagSelection [
	<noTest>
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
	<noTest>
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
	<noTest>
	<gtExample>
	| anElement aPackageNode |
	anElement := self elementWithPackageWithoutTagsAndExtensionsSelection.
	aPackageNode := anElement selectedPackageNodeDo: [ :aNode | aNode ].
	self assert: aPackageNode isNotNil.
	self assert: aPackageNode childrenValues size equals: 0.
	^ anElement
]

{ #category : #'examples - class selection' }
GtCoderNavigationPackagesTagsClassesElementExamples >> elementWithUnategorizedPackageTagAndClassSelection [
	<noTest>
	<gtExample>
	| anElement |
	anElement := self elementNavigationModelInSpace.
	anElement navigationModel selectClass: self classInUncategorizedPackageTag.
	self 
		assertSelectionOfPackage: nil
		tag: self uncategorizedPackageTag 
		class: self classInUncategorizedPackageTag 
		inElement: anElement.
	^ anElement
]

{ #category : #'examples - class selection' }
GtCoderNavigationPackagesTagsClassesElementExamples >> elementWithUnategorizedPackageTagAndClassSelection_BeforeInSpace [
	<noTest>
	<gtExample>
	| anElement |
	anElement := self elementNavigationModel.
	anElement navigationModel selectClass: self classInUncategorizedPackageTag.
	self putInSpace: anElement.
	self 
		assertSelectionOfPackage: nil
		tag: self uncategorizedPackageTag 
		class: self classInUncategorizedPackageTag 
		inElement: anElement.
	^ anElement
]

{ #category : #accessing }
GtCoderNavigationPackagesTagsClassesElementExamples >> numberOfSubscriptions [
	<gtExample>
	| aMethodOne aMethodTwo theGlobalsOne theGlobalsTwo theGlobals |
	aMethodOne := GtCoderNavigationElement >> #subscribeToNavigationModel.
	theGlobalsOne := aMethodOne ast allVariables select: #isGlobal.
	aMethodTwo := GtCoderNavigationPackagesTagsClassesElement >> #subscribeToNavigationModel.
	theGlobalsTwo := aMethodTwo ast allVariables select: #isGlobal.
	theGlobals := theGlobalsOne, theGlobalsTwo.
	self assert: theGlobals size > 9.
	^ theGlobals size
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

{ #category : #'examples - system items' }
GtCoderNavigationPackagesTagsClassesElementExamples >> uncategorizedPackageTag [
	<gtExample>
	| aPackage aPackageTag aTag |
	aPackage := self classInUncategorizedPackageTag package.
	aPackageTag := aPackage classTags detect: [ :eachTag | eachTag name = aPackage name ].
	aTag := GtCoderPackageUncategorizedTag forPackageTag: aPackageTag.
	self assert: (aTag = aPackageTag).
	self assert: (aTag = aPackage) not.
	self assert: (aTag = self packageTag) not.
	^ aTag
]
