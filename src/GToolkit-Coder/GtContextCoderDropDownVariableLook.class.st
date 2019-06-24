Class {
	#name : #GtContextCoderDropDownVariableLook,
	#superclass : #BrLook,
	#instVars : [
		'methodCoder'
	],
	#category : #'GToolkit-Coder-Looks'
}

{ #category : #initialization }
GtContextCoderDropDownVariableLook >> badgeButton [
	^ BrButton new
		background: Color orange;
		label:
			('Vars' asRopedText
				fontSize: 15;
				foreground: Color white;
				bold);
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ];
		look: BrTextLabelLook;
		padding: (BlInsets all: 7)
]

{ #category : #initialization }
GtContextCoderDropDownVariableLook >> dropDownElement [
	| dropdown |
	dropdown := BrDropdown new
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c | 
			c ignoreByLayout.
			c ignored horizontal alignRight.
			c ignored vertical alignTop ].
	dropdown toggle: [ self badgeButton ].
	dropdown popup: [ self variablesElement ].
	dropdown
		look:
			(BrGlamorousDropdownLook new
				popupEmbellisher: [ :aPopupElement :aToggleStencil | 
					| aContainer aPopupWrapper |
					self flag: 'FIXME is this still used? this should rather not override the popupEmbellisher, instead use the popup or outskirtsEmbellisher'.
					aPopupWrapper := BlElement new
						layout: BlLinearLayout vertical;
						constraintsDo: [ :c | 
							c horizontal fitContent.
							c vertical fitContent ].
					aPopupWrapper addChild: aPopupElement.
					aPopupWrapper border: (BlBorder paint: Color orange width: 1).
					aPopupWrapper background: Color white.
					aContainer := BlElement new.
					aContainer clipChildren: false.
					aContainer layout: BlLinearLayout vertical.
					aContainer
						constraintsDo: [ :c | 
							c horizontal fitContent.
							c vertical fitContent ].
					aContainer
						addChild:
							(aToggleStencil asElement
								elevation: (BlRelativeElevation elevation: 2)).
					aContainer addChild: aPopupWrapper ]).
	^ dropdown
]

{ #category : #accessing }
GtContextCoderDropDownVariableLook >> initialize [
	super initialize.
	self
		addChangeAddChildAs: #(content dropdown)
		with: [ self dropDownElement ]
]

{ #category : #accessing }
GtContextCoderDropDownVariableLook >> methodCoder [
	^ methodCoder
]

{ #category : #accessing }
GtContextCoderDropDownVariableLook >> methodCoder: aMethodCoder [
	methodCoder := aMethodCoder
]

{ #category : #generated }
GtContextCoderDropDownVariableLook >> variables [
	| vars |
	vars := OrderedCollection new.
	methodCoder tempNamesAndValuesDo: [ :name :value | vars add: {name. 'temporary'. value} ].
	methodCoder instanceVariableNamesAndValuesDo: [ :name :value | vars add: {name. 'instance'. value} ].
	vars sort: [ :a :b | a first < b first ].
	vars addFirst: {'self'. 'self'. methodCoder receiver}.
	methodCoder stackVariableNamesAndValuesDo: [ :name :value | vars add: {name. 'stack'. value} ].
	^ vars
]

{ #category : #initialization }
GtContextCoderDropDownVariableLook >> variablesElement [
	| variablesElement |
	variablesElement := BrColumnedList new.
	variablesElement
		addEventHandler:
			(GtInspectorListToSelectHandler new
				transformation: [ :each | each last ]).
	variablesElement column
		title: 'Variable';
		stencil: [ :each | 
			BrLabel new
				look: (BrGlamorousLabelLook new foreground: Color black);
				text: each first asString;
				hMatchParent;
				vMatchParent ].
	variablesElement column
		title: 'Value';
		stencil: [ :each | 
			BrLabel new
				look: (BrGlamorousLabelLook new foreground: Color black);
				text: (each last printStringLimitedTo: 50);
				hMatchParent;
				vMatchParent ].
	variablesElement display: self variables.
	^ variablesElement
]
