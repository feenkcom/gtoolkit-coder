Class {
	#name : #GtFiltersElementExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Filters - UI'
}

{ #category : #'examples - support' }
GtFiltersElementExamples >> basicFilteredMethodsCoder [
	<gtExample>
	| aCoder |
	aCoder := GtClassMethodsCoder new.
	^ aCoder
]

{ #category : #'examples - ui' }
GtFiltersElementExamples >> basicFiltersElement [
	<gtExample>
	| anElement |
	anElement := GtFiltersElement new.
	self assert: anElement descriptors isNil.
	self assert: anElement childrenCount equals: 1.
	self assert: (anElement childAt: 1) class equals: BrButton.
	^ anElement
]

{ #category : #'examples - ui' }
GtFiltersElementExamples >> coderWithFiltersElement [
	<gtExample>
	| aFiltersElement aCoder aCoderElement aTag aButton |
	aCoder := self filteredMethodsCoder.
	aCoderElement := aCoder asElement.
	aFiltersElement := self filtersElemenFrom: aCoderElement.
	self assert: aFiltersElement descriptors isNotNil.
	self assert: aFiltersElement descriptors isNotEmpty.
	self assert: aFiltersElement childrenCount > 1.
	
	"Check whether the default filter is Category filter"
	aTag := aFiltersElement childAt: 1.
	self assert: aTag class equals: GtFilterTagElement.
	aButton := aTag childAt: 1.
	self assert: aButton class equals: BrButton.
	self assert: aButton label asString equals: 'Category'.
	^ aCoder
]

{ #category : #'examples - ui' }
GtFiltersElementExamples >> filterTagElement [
	<gtExample>
	| aFiltersElement aTagElement |
	aFiltersElement := self filtersElement.
	aTagElement := aFiltersElement childAt: 1.
	self assert: aTagElement class equals: GtFilterTagElement.
	aTagElement removeFromParent.
	^ aTagElement
]

{ #category : #'examples - support' }
GtFiltersElementExamples >> filteredMethodsCoder [
	<gtExample>
	| aCoder aClass |
	aCoder := self basicFilteredMethodsCoder.
	aClass := GtFiltersDummyObjectWithExamples.
	aCoder forClass: aClass.
	self assert: aCoder classOrMetaClass equals: aClass.
	^ aCoder
]

{ #category : #'examples - ui' }
GtFiltersElementExamples >> filtersElemenFrom: aCoderElement [
	<gtExample>
	| aFiltersElement |
	aFiltersElement := aCoderElement childAt: 1.
	self assert: aFiltersElement class equals: GtFiltersElement.
	^ aFiltersElement
]

{ #category : #'examples - ui' }
GtFiltersElementExamples >> filtersElement [
	<gtExample>
	| aFiltersElement aCoder aCoderElement |
	aCoder := self coderWithFiltersElement.
	aCoderElement := aCoder asElement.
	aFiltersElement := self filtersElemenFrom: aCoderElement.
	aFiltersElement removeFromParent.
	^ aFiltersElement
]
