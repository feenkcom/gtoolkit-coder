Class {
	#name : #GtFilterElementByScripterExamples,
	#superclass : #Object,
	#traits : 'TBlDevScripterExamples',
	#classTraits : 'TBlDevScripterExamples classTrait',
	#category : #'GToolkit-Coder-Examples-Filters - New'
}

{ #category : #examples }
GtFilterElementByScripterExamples >> booleanElement [
	<gtExample>
	<return: #BlScripter>
	| aScripter |
	aScripter := self
			scripterWithModel: [ GtFilterModelExamples new booleanModel ]
			element: [ :aModel | aModel asFilterLabeledElement ].

	^ aScripter
]

{ #category : #examples }
GtFilterElementByScripterExamples >> itemsModel [
	<gtExample>
	<return: #BlScripter>
	| aScripter |
	aScripter := self
			scripterWithModel: [ GtFilterModelExamples new itemsModel ]
			element: [ :aModel | GtFilterItemsElement new filtersViewModel: aModel asFiltersViewModel ].



	^ aScripter
]

{ #category : #examples }
GtFilterElementByScripterExamples >> shortListElement [
	<gtExample>
	<return: #BlScripter>
	| aScripter |
	aScripter := self
			scripterWithModel: [ GtFilterModelExamples new shortListModel ]
			element: [ :aModel | aModel asFilterLabeledElement ].

	^ aScripter
]

{ #category : #examples }
GtFilterElementByScripterExamples >> textElement [
	<gtExample>
	<return: #BlScripter>
	| aScripter |
	aScripter := self
			scripterWithModel: [ GtFilterModelExamples new textModel ]
			element: [ :aModel | aModel asFilterLabeledElement ].

	aScripter editor
		click;
		selectAll;
		typeText: 'Class';
		assertTextEqualsTo: 'Class';
		// GtFilterSettingsId;
		play.

	^ aScripter
]
