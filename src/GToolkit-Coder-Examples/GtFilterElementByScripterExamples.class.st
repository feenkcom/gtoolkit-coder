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
	| aScripter |
	aScripter := self
			scripterWithModel: [ GtFilterModelExamples new booleanModel ]
			element: [ :aModel | GtFilterNameElement new filterViewModel: aModel asFilterViewModel ].

	^ aScripter
]

{ #category : #examples }
GtFilterElementByScripterExamples >> shortListElement [
	<gtExample>
	| aScripter |
	aScripter := self
			scripterWithModel: [ GtFilterModelExamples new shortListModel ]
			element: [ :aModel | GtFilterNameElement new filterViewModel: aModel asFilterViewModel ].

	^ aScripter
]

{ #category : #examples }
GtFilterElementByScripterExamples >> textElement [
	<gtExample>
	| aScripter |
	aScripter := self
			scripterWithModel: [ GtFilterModelExamples new textModel ]
			element: [ :aModel | GtFilterNameElement new filterViewModel: aModel asFilterViewModel ].

	aScripter editor
		click;
		selectAll;
		typeText: 'Class';
		assertTextEqualsTo: 'Class';
		// GtFilterSettingsId;
		play.

	^ aScripter
]
