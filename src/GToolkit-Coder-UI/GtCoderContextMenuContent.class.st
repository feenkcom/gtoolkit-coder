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
				addAptitude:
					(BrStyleCommonAptitude new
						hovered:
							[ :aStyle | aStyle background: self theme button defaultBorderColor ]);
				padding: (BlInsets all: 5);
				when: BlClickEvent
					do: [ :anEvent | 
					anEvent consumed: true.
					eachGtCoderContextMenuAction action
						cull: self editorElement textualCoderViewModel
						cull: anEvent
						cull: self editorElement.
					self fireEvent: BrDropdownHideWish new.
					self fireEvent: BrContextMenuHideWish new ];
				addChild:
					(BrLabel new
						aptitude: BrGlamorousLabelAptitude;
						text: eachGtCoderContextMenuAction title;
						yourself).
			eachGtCoderContextMenuAction hoverAction
				ifNotNil: [ :hover | 
					element
						when: BlMouseEnterEvent
						do: [ :anEvent | hover cull: self editorElement cull: anEvent ] ].
			eachGtCoderContextMenuAction leaveAction
				ifNotNil: [ :leave | 
					element
						when: BlMouseLeaveEvent
						do: [ :anEvent | leave cull: self editorElement cull: anEvent ] ].
			eachGtCoderContextMenuAction name
				ifNotNil: [ :anActionName | element containerName: anActionName ].
			element ];
		hFitContent;
		vFitContent
]
