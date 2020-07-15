Class {
	#name : #GtCoderNavigationElementExamples,
	#superclass : #Object,
	#instVars : [
		'elements',
		'spaces'
	],
	#category : #'GToolkit-Coder-Examples-Navigation'
}

{ #category : #asserting }
GtCoderNavigationElementExamples >> assertSelectionOfPackage: aRPackage tag: aRPackageTag class: aClass inModel: aModel [

	self assert: aModel selectedPackage equals: aRPackage.
	self assert: aModel selectedTag equals: aRPackageTag.
	self assert: aModel selectedClass equals: aClass.
]

{ #category : #'examples - navigation model' }
GtCoderNavigationElementExamples >> basicPackageTagsClassesNavigation [
	<gtExample>
	| aModel |
	aModel := GtCoderNavigationPackagesTagsClassesModel new.
	self assertSelectionOfPackage: nil tag: nil class: nil inModel: aModel.
	^ aModel
]

{ #category : #'examples - space' }
GtCoderNavigationElementExamples >> closeSpaces [
	elements do: #removeFromParent.
	spaces do: #close.
]

{ #category : #initialization }
GtCoderNavigationElementExamples >> initialize [
	super initialize.
	elements := OrderedCollection new: 1.
	spaces := OrderedCollection new: 1.
]

{ #category : #'examples - space' }
GtCoderNavigationElementExamples >> newSpace [
	<gtExample>
	| aSpace |
	aSpace := BlSpace new.
	aSpace host: BlHeadlessHost new.
	aSpace title: 'Documenter Examples'.
	aSpace extent: 600@400.
	aSpace withHalos.
	^ aSpace
]

{ #category : #'examples - space' }
GtCoderNavigationElementExamples >> putInSpace: aBlElement [
	<gtExample>
	| aSpace |
	self 
		assert: [ aBlElement isNotNil ]
		description: [ 'Element must be non-nil' ].
	aSpace := self newSpace.
	aSpace root addChild: aBlElement.
	self registerSpace: aSpace element: aBlElement.
	^ aSpace
]

{ #category : #'examples - space' }
GtCoderNavigationElementExamples >> registerSpace: aSpace element: aBlElement [
	<gtExample>
	<after: #closeSpaces>
	spaces add: aSpace.
	elements add: aBlElement.
]

{ #category : #'examples - navigation model' }
GtCoderNavigationElementExamples >> selectPackage: aRPackage in: aModel [
	<gtExample>
	aModel selectPackage: aRPackage.
	self assert: aModel selectedPackage equals: aRPackage.
	self assert: aModel selectedTag isNil.
	self assert: aModel selectedClass isNil.
]
