"
I examplify ${class:GtCoderElement}$ and its subclasses.
"
Class {
	#name : #GtCoderElementExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-UI'
}

{ #category : #'examples - content element' }
GtCoderElementExamples >> basicContentElement [
	<gtExample>
	| anElement |
	anElement := GtCoderContentElement new.
	self assert: anElement navigationModel == GtCoderNavigationModel null.
	self assert: anElement childrenCount isZero.
	^ anElement
]

{ #category : #'examples - navigation model' }
GtCoderElementExamples >> basicNavigationModel [
	<gtExample>
	^ GtCoderNavigationPackagesTagsClassesModel new
]

{ #category : #'examples - playground' }
GtCoderElementExamples >> basicPlaygroundElement [
	<gtExample>
	| anElement |
	anElement := GtCoderPlaygroundElement new.
	self assert: anElement navigationModel == GtCoderNavigationModel null.
	self assert: anElement childrenCount equals: 2.
	^ anElement
]

{ #category : #'examples - toolbar' }
GtCoderElementExamples >> basicToolbarElement [
	<gtExample>
	| anElement |
	anElement := GtCoderToolbarElement new.
	self assert: anElement navigationModel == GtCoderNavigationModel null.
	self assert: anElement childrenCount equals: 1.
	^ anElement
]

{ #category : #'examples - coders' }
GtCoderElementExamples >> classCoder [
	<gtExample>
	^ GtBehaviorCoder forClass: self class
]

{ #category : #'examples - coder element' }
GtCoderElementExamples >> coderElement [
	<gtExample>
	| anElement |
	anElement := GtCoder new.
	^ anElement
]

{ #category : #'examples - coder element' }
GtCoderElementExamples >> coderElementWithObject [
	<gtExample>
	| anElement |
	anElement := GtCoder forObject: self.
	^ anElement
]

{ #category : #'examples - content element' }
GtCoderElementExamples >> contentElementWithClass [
	<gtExample>
	| anElement |
	anElement := self basicContentElement.
	self pushClassCoderInto: anElement.
	self assert: anElement childrenCount equals: 1.
	^ anElement
]

{ #category : #'examples - content element' }
GtCoderElementExamples >> contentElementWithPackages [
	<gtExample>
	| anElement aModel |
	anElement := self basicContentElement.
	aModel := self basicNavigationModel.
	anElement navigationModel: aModel.
	anElement pushCoder: self packagesCoder.
	self assert: anElement navigationModel equals: aModel.
	self assert: anElement childrenCount equals: 1.
	^ anElement
]

{ #category : #'examples - coders' }
GtCoderElementExamples >> packagesCoder [
	<gtExample>
	^ GtPackagesCoder new
]

{ #category : #'examples - playground' }
GtCoderElementExamples >> playgroundElementWithClass [
	<gtExample>
	| anElement |
	anElement := self basicPlaygroundElement.
	self pushClassCoderInto: anElement.
	self assert: anElement childrenCount equals: 2.
	self assert: anElement children first class equals: GtCoderContentElement.
	self assert: anElement children first childrenCount isZero not.
	self assert: anElement playPage receiver equals: self class.
	^ anElement
]

{ #category : #'examples - support' }
GtCoderElementExamples >> pushClassCoderInto: anElement [
	<gtExample>
	| aModel |
	aModel := self basicNavigationModel.
	anElement navigationModel: aModel.
	anElement pushCoder: self classCoder.
	self assert: anElement navigationModel equals: aModel.
	self assert: aModel selectedClass equals: self class.
]

{ #category : #'examples - toolbar' }
GtCoderElementExamples >> toolbarElementWithClass [
	<gtExample>
	| anElement |
	anElement := self basicToolbarElement.
	self pushClassCoderInto: anElement.
	self assert: anElement childrenCount equals: 1.
	^ anElement
]
