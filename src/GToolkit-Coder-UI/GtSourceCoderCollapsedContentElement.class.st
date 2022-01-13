Class {
	#name : #GtSourceCoderCollapsedContentElement,
	#superclass : #GtSourceCoderContentElement,
	#instVars : [
		'label',
		'addOns',
		'content',
		'previews'
	],
	#category : #'GToolkit-Coder-UI-Coder - Source'
}

{ #category : #initialization }
GtSourceCoderCollapsedContentElement >> initialize [
	super initialize.
	
	content := BlElement new
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ].

	label := self newLabel.
	addOns := self newAddOnsContainer.

	previews := Dictionary new.

	content addChildren: { label. addOns }.
	self addChild: content.
]

{ #category : #'instance creation' }
GtSourceCoderCollapsedContentElement >> newAddOnsContainer [
	^ BrHorizontalPane new
		matchParent;
		alignCenterLeft;
		margin: (BlInsets left: 5);
		withAsyncPromiseDo: [ :anElementPromise |
			anElementPromise
				whenSuccess: [ :aContainer :theAddOns |
					aContainer removeChildren.
					theAddOns previews do: [ :eachAddOn |
						| eachAddOnElement |

						eachAddOnElement := previews
							at: eachAddOn id
							ifAbsentPut: [ eachAddOn stencil asElement ].
						
						eachAddOn dataBinder
							element: eachAddOnElement;
							coderViewModel: textualCoderViewModel;
							build.

						aContainer addChild: eachAddOnElement ] ];
				whenError: [ :aContainer :anError |
					aContainer removeChildren.
					aContainer addChild: (BrLabel new aptitude: BrGlamorousLabelAptitude; text: anError printString) ];
				whenPending: [ :aContainer | ] ]
]

{ #category : #'instance creation' }
GtSourceCoderCollapsedContentElement >> newLabel [
	^ BlAttributedTextElement new
		id: GtSourceCoderCollapsedTextId;
		editorMeasurement;
		bold;
		glamorousCodeFont;
		withAsyncPromiseDo: [ :anElementPromise |
			anElementPromise
				whenSuccess: [ :aLabel :aText | aLabel text: aText asRopedText ];
				whenError: [ :aLabel :anError | aLabel text: anError printString asRopedText ];
				whenPending: [ :aLabel | aLabel text: '' asRopedText ] ]
]

{ #category : #'api - textual coder view model' }
GtSourceCoderCollapsedContentElement >> onTextualCoderViewModelChanged [
	super onTextualCoderViewModelChanged.
	
	label asyncPromise promise: textualCoderViewModel collapsedTextPromise.
	addOns removeChildren.
	addOns asyncPromise promise: textualCoderViewModel addOns
]
