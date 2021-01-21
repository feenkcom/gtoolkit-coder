Class {
	#name : #GtCoderContextMenuContent,
	#superclass : #BrSimpleList,
	#instVars : [
		'editorElement'
	],
	#category : #'GToolkit-Coder-UI-Basic'
}

{ #category : #defaults }
GtCoderContextMenuContent >> defaultContextMenuActionName [
	^ #contextMenuAction
]

{ #category : #defaults }
GtCoderContextMenuContent >> defaultLabelChildName [
	^ #label
]

{ #category : #'api - accessing' }
GtCoderContextMenuContent >> editorElement [
	<return: #BrEditorElement>
	^ editorElement
]

{ #category : #'api - accessing' }
GtCoderContextMenuContent >> editorElement: anEditorElement [
	self 
		assert: [ anEditorElement isNotNil ] 
		description: [ 'Editor element must be non-nil' ].
	editorElement := anEditorElement
]

{ #category : #initialization }
GtCoderContextMenuContent >> initialize [
	super initialize.
	self
		stencil: [ :eachGtCoderContextMenuAction | 
			| element |
			element := BrHorizontalPane new
				hMatchParent;
				vFitContent;
				addLook: (BrStyleCommonLook new
					hovered: [ :aStyle | aStyle background: BrGlamorousColors defaultButtonBorderColor ]);
				padding: (BlInsets all: 5);
				when: BlClickEvent
					do: [ :anEvent |
						anEvent consumed: true.
						eachGtCoderContextMenuAction action cull: self editorElement cull: self anchor.
						self fireEvent: BrDropdownHideWish new.
						self fireEvent: BrContextMenuHideWish new ];
				addChild:
					(BrLabel new
						look: BrGlamorousLabelLook;
						text: eachGtCoderContextMenuAction title;
						yourself).
			eachGtCoderContextMenuAction hoverAction
				ifNotNil: [ :hover | 
					element
						when: BlMouseEnterEvent
						do: [ :anEvent | hover cull: self editorElement cull: self anchor ] ].
			eachGtCoderContextMenuAction leaveAction
				ifNotNil: [ :leave | 
					element
						when: BlMouseLeaveEvent
						do: [ :anEvent | leave cull: self editorElement cull: self anchor ] ].
			
			eachGtCoderContextMenuAction name
				ifNotNil: [ :anActionName | element containerName: anActionName ].
			
			element ];
		hFitContent;
		vFitContent
]
