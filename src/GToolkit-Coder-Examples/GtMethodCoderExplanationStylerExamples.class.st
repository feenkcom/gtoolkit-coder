Class {
	#name : #GtMethodCoderExplanationStylerExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-By scripter'
}

{ #category : #dummies }
GtMethodCoderExplanationStylerExamples >> a [
	<gtExample>
	^ 42
]

{ #category : #dummies }
GtMethodCoderExplanationStylerExamples >> a: arg1 a: arg2 a: arg3 a: arg4 [
	"test method for highlighting implementors"
]

{ #category : #accessing }
GtMethodCoderExplanationStylerExamples >> attributeCountOfType: aClass in: aTextEditor [
	| text iterator count |
	count := 0.
	text := aTextEditor text.
	iterator := text iterator.
	[ iterator hasNext ]
		whileTrue: [ (iterator attributes anySatisfy: [ :each | each isKindOf: aClass ])
				ifTrue: [ count := count + 1 ].
			iterator next ].
	^ count
]

{ #category : #dummies }
GtMethodCoderExplanationStylerExamples >> b [
	<gtExample>
	^ self a * self notAnExample
]

{ #category : #examples }
GtMethodCoderExplanationStylerExamples >> coderOnViewMethod [
	<gtExample>
	| selectors variables coder coderViewModel coderElement |
	
	selectors := GtSelectorExplanationLinkStyler new.
	selectors addSelectors: #(gtView columnedList title: items: contacts fullName avatar telephone contacts).
	selectors addSelector: #column:icon: withIdentifier: #columns.
	selectors addSelector: #column:icon:width: withIdentifier: #columns.
	selectors addSelector: #column:text: withIdentifier: #columns.
	
	variables := GtVariableExplanationLinkStyler new.
	variables addVariables: {'aView' . 'aContact'}.
	
	coder := GtPharoMethodCoder forMethod: (GtABAddressBook>>#gtViewContactsOn:).
	coderViewModel := coder asCoderViewModel.
	coderViewModel addStylers: { selectors. variables }.
	coderViewModel expanded: true.

	coderElement := coderViewModel asElement.
	coderElement margin: (BlInsets all: 10).
	coderElement vMatchParent.

	^ coderElement
]

{ #category : #examples }
GtMethodCoderExplanationStylerExamples >> explanationLinkExample [
	<gtExample>
	| container inspectorContainer editor coder coderViewModel coderElement selectors variables |
	
	inspectorContainer := BlElement new
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ];
		layout: BlLinearLayout horizontal;
		background: Color white;
		margin: (BlInsets all: 10);
		aptitude: BrShadowAptitude.
	container := BlElement new
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ];
		layout: BlLinearLayout horizontal.
	container explainer isExplanationHolder: true.
	
	selectors := GtSelectorExplanationLinkStyler new.
	selectors addSelectors: #(syntaxOn: not + size < do: show:).

	variables := GtVariableExplanationLinkStyler new.
	variables addVariables: {'self'. 'y' }.
	
	coder := GtPharoMethodCoder forMethod: (GtPharoMethodExample>>#exampleWithNumber:).	
	coderViewModel := coder asCoderViewModel.
	coderViewModel addStylers: { variables. selectors }.
	coderViewModel expanded: true.
	
	coderElement := coderViewModel asElement.
	coderElement forceLayout.
	inspectorContainer addChild: coderElement.
	
	editor := BrEditor new
		aptitude: BrGlamorousRegularEditorAptitude;
		text: self explanationLinkExampleText;
		margin: (BlInsets all: 10);
		constraintsDo: [ :c | 
			c vertical matchParent.
			c horizontal matchParent.
			c linear weight: 0.3 ].
	
	container addChild: editor.
	container addChild: inspectorContainer.
	^ container.
]

{ #category : #examples }
GtMethodCoderExplanationStylerExamples >> explanationLinkExampleText [
	<gtExample>
	| text |
	
	text := ('pragma' asRopedText glamorousExplanationFor: #syntaxOn:),
	'
' asRopedText,
	('not' asRopedText glamorousExplanationFor: #not),
	'
' asRopedText,
	('addition' asRopedText glamorousExplanationFor: #+),
	'
' asRopedText,
	('size' asRopedText glamorousExplanationFor: #size),
	'
' asRopedText,
	('comparison' asRopedText glamorousExplanationFor: #<),
	'
' asRopedText,
	('do' asRopedText glamorousExplanationFor: #do:),
	'
' asRopedText,
	('show' asRopedText glamorousExplanationFor: #show:),
	'
' asRopedText,
	('self' asRopedText glamorousExplanationFor: #self),
	'
' asRopedText,
	('variable y' asRopedText glamorousExplanationFor: #y).
	
	^text
		glamorousRegularFont;
		foreground: Color black.
]

{ #category : #accessing }
GtMethodCoderExplanationStylerExamples >> hasAttributeOfType: aClass in: aTextEditor [
	^ (self attributeCountOfType: aClass in: aTextEditor) > 0
]

{ #category : #accessing }
GtMethodCoderExplanationStylerExamples >> hasExampleExpandAttributeIn: coder [
	^ self hasAttributeOfType: BrGlamorousTrangleExpanderTextAttribute in: coder sourceEditor
]

{ #category : #accessing }
GtMethodCoderExplanationStylerExamples >> hasExampleStatusIn: coder [
	| collapsedAttribute sourceAttribute |
	sourceAttribute := self
		hasAttributeOfType: GtCoderExampleStatusAttribute
		in: coder sourceEditor.
	coder
		expanded: false;
		expanded: true.	"need to collapse to compute collapsed text style"
	collapsedAttribute := self
		hasAttributeOfType: GtCoderExampleStatusAttribute
		in: coder collapsedText.
	self assert: sourceAttribute = collapsedAttribute.
	^ sourceAttribute
]

{ #category : #accessing }
GtMethodCoderExplanationStylerExamples >> hasUnderlineAttributeIn: coder [
	^ self hasAttributeOfType: self unlineAttributeClass in: coder sourceEditor
]

{ #category : #examples }
GtMethodCoderExplanationStylerExamples >> inspectorOnViewMethod [
	<gtExample>
	| resultElement resultInspectorTree titleTab avatarLabel phoneLabel nameLabel avatarElementsCollection listLabelsCollection |
	
	resultElement := BlUseAsyncFeatures
		disableDuring: [ (GtPhlowView empty composite
				views:
					{(GtABCartoonAddressBookExample new cartoonAddressBook
						gtViewContactsOn: GtPhlowView empty)};
				labelled: 'a GtABAddressBook (Cartoons)' asRopedText)
				asElementDo: [ :e | e ] ].
	resultElement forceLayout.
	resultInspectorTree := resultElement phlow firstChildWithView viewContentElement.
	
	titleTab := resultInspectorTree
		allChildrenBreadthFirstDetect: [ :aChild | 
			(aChild isKindOf: BrTab)
				and: [ aChild label asString = 'Contacts with details' ] ]
		ifFound: [ :aChild | aChild ].
	avatarLabel := resultInspectorTree
		allChildrenBreadthFirstDetect:
			[ :aChild | (aChild isKindOf: BrLabel) and: [ aChild text asString = 'Avatar' ] ]
		ifFound: [ :aChild | aChild ].
	nameLabel := resultInspectorTree
		allChildrenBreadthFirstDetect:
			[ :aChild | (aChild isKindOf: BrLabel) and: [ aChild text asString = 'Name' ] ]
		ifFound: [ :aChild | aChild ].
	phoneLabel := resultInspectorTree
		allChildrenBreadthFirstDetect:
			[ :aChild | (aChild isKindOf: BrLabel) and: [ aChild text asString = 'Phone' ] ]
		ifFound: [ :aChild | aChild ].
	avatarElementsCollection := resultInspectorTree
		allChildrenBreadthFirstSelect: [ :aChild | 
			(aChild isKindOf: BrHorizontalPane) ].
	listLabelsCollection := resultInspectorTree
		allChildrenBreadthFirstSelect: [ :aChild | 
			(aChild isKindOf: BlTextElement)
				and: [ aChild parent parent isKindOf: GtPhlowCellElement ] ].

	titleTab
		addChild:
			(BrButton new
				constraintsDo: [ :c | c ignoreByLayout ];
				size: 5 @ 5;
				elevation: (BlRelativeElevation elevation: 10);
				geometry: BlCircle new;
				aptitude: (GtExplainerTargetAptitude new explanationModel: #title:);
				relocate: 10 @ titleTab extent y / 2).
	avatarLabel
		addChild:
			(BrButton new
				constraintsDo: [ :c | c ignoreByLayout ];
				size: 5 @ 5;
				elevation: (BlRelativeElevation elevation: 10);
				geometry: BlCircle new;
				aptitude: (GtExplainerTargetAptitude new explanationModel: #columns);
				relocate: 5 @ avatarLabel extent y / 2).
	nameLabel
		addChild:
			(BrButton new
				constraintsDo: [ :c | c ignoreByLayout ];
				size: 5 @ 5;
				elevation: (BlRelativeElevation elevation: 10);
				geometry: BlCircle new;
				aptitude: (GtExplainerTargetAptitude new explanationModel: #columns);
				relocate: 5 @ nameLabel extent y / 2).
	phoneLabel
		addChild:
			(BrButton new
				constraintsDo: [ :c | c ignoreByLayout ];
				size: 5 @ 5;
				elevation: (BlRelativeElevation elevation: 10);
				geometry: BlCircle new;
				aptitude: (GtExplainerTargetAptitude new explanationModel: #columns);
				relocate: 5 @ phoneLabel extent y / 2).
	avatarElementsCollection
		do: [ :eachAvatar | 
			eachAvatar parent
				addChild:
					(BrButton new
						constraintsDo: [ :c | c ignoreByLayout ];
						size: 5 @ 5;
						elevation: (BlRelativeElevation elevation: 10);
						geometry: BlCircle new;
						aptitude: (GtExplainerTargetAptitude new explanationModel: #avatar);
						relocate: 0 @ eachAvatar extent y / 2) ].			
	listLabelsCollection
		do: [ :eachLabel | 
			| modelName |
			modelName := (eachLabel text asString beginsWith: '+' asString)
				ifTrue: [ #telephone ]
				ifFalse: [ #fullName ].
			eachLabel
				addChild:
					(BrButton new
						constraintsDo: [ :c | c ignoreByLayout ];
						size: 5 @ 5;
						elevation: (BlRelativeElevation elevation: 10);
						geometry: BlCircle new;
						aptitude: (GtExplainerTargetAptitude new explanationModel: modelName);
						relocate: -5 @ eachLabel extent y / 2) ].
	
	^ resultElement.
]

{ #category : #dummies }
GtMethodCoderExplanationStylerExamples >> notAnExample [
	^ 42
]

{ #category : #dummies }
GtMethodCoderExplanationStylerExamples >> printStringReference [
	^ self printString
]

{ #category : #accessing }
GtMethodCoderExplanationStylerExamples >> unlineAttributeClass [
	^ BlTextDecorationAttribute
]

{ #category : #examples }
GtMethodCoderExplanationStylerExamples >> viewsExplanationWithLinks [
	<gtExample>
	| container editor |
	
	container := BlElement new
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ];
		margin: (BlInsets all: 30);
		background: Color white;
		aptitude: BrShadowAptitude;
		layout: BlLinearLayout horizontal.
	container explainer isExplanationHolder: true.
	
	editor := BrEditor new
		aptitude: (BrGlamorousRegularEditorAptitude new fontSize: 16);
		text: self viewsExplanationWithLinksText;
		margin: (BlInsets all: 10);
		constraintsDo: [ :c | 
			c vertical fitContent.
			c horizontal matchParent.
			c linear weight: 0.5 ].
		
	container addChild: editor.
	container addChild: self coderOnViewMethod.
	^ container
]

{ #category : #examples }
GtMethodCoderExplanationStylerExamples >> viewsExplanationWithLinksOnCoderAndInspector [
	<gtExample>
	| coderElement inspectorContainer verticalContainer editor container |
	
	container := BlElement new
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent];
		layout: BlLinearLayout horizontal alignCenter.
	container explainer isExplanationHolder: true.
	
	verticalContainer := BlElement new
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent.
			c padding: (BlInsets all: 5)];
		layout: BlLinearLayout vertical.
	
	inspectorContainer := BlElement new
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ];
		layout: BlLinearLayout horizontal;
		aptitude: BrShadowAptitude;
		background: Color white;
		margin: (BlInsets all: 10).
	
	coderElement := self coderOnViewMethod.
	inspectorContainer addChild: self inspectorOnViewMethod.
	
	verticalContainer
		addChild: coderElement;
		addChild: inspectorContainer.
	
	editor := BrEditor new
		aptitude: (BrGlamorousRegularEditorAptitude new fontSize: 16);
		text: self viewsExplanationWithLinksText;
		margin: (BlInsets all: 10);
		constraintsDo: [ :c | 
			c vertical fitContent.
			c horizontal matchParent.
			c linear weight: 0.5 ].
	
	^ container
		addChild: editor;
		addChild: verticalContainer.
]

{ #category : #accessing }
GtMethodCoderExplanationStylerExamples >> viewsExplanationWithLinksText [
	| text |
	
	text := 'A custom view is defined by a method in the class of the object we want to view. You can think of it as a print string method only that instead of returning a string, it returns a visual element.
As we can have many such representations for every single object, we have to identify the method that defines a view. This is achieved through the ' asRopedText,
('gtView' asRopedText glamorousExplanationFor: #gtView),
' pragma.
The method takes an empty ' asRopedText,
('view' asRopedText glamorousExplanationFor: #aView),
' parameter that you can customize.
In our case the view consists of a ' asRopedText,
('columned list' asRopedText glamorousExplanationFor: #columnedList),
' with ' asRopedText,
('three columns' asRopedText glamorousExplanationFor: #columns),
' and a ' asRopedText,
('title' asRopedText glamorousExplanationFor: #title:),
'
The columned list has as many rows as the collection returned by the ' asRopedText,
('items: block' asRopedText glamorousExplanationFor: #items:),
'. In this case, this means it shows all the ' asRopedText,
('contacts list' asRopedText glamorousExplanationFor: #contacts),
'For each ' asRopedText, 
('contact' asRopedText glamorousExplanationFor: #aContact),
' it shows the ' asRopedText,
('avatar' asRopedText glamorousExplanationFor: #avatar),
' in the first column, the ' asRopedText,
('full name' asRopedText glamorousExplanationFor: #fullName),
' in the second column, and the ' asRopedText,
('telephone' asRopedText glamorousExplanationFor: #telephone),
' in the third column.
That''s it. That''s the whole specification.' asRopedText.
	^ text
		glamorousRegularFont;
		fontSize: 20;
		foreground: Color black.
]
