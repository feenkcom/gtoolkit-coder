Class {
	#name : #GtCoderContextMenuContent,
	#superclass : #BrSimpleList,
	#instVars : [
		'editorElement'
	],
	#category : #'GToolkit-Coder-UI-Basic'
}

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
					addAptitude: (BrStyleCommonAptitude new
							hovered: [ :aStyle | aStyle background: self theme item selectedColor ]);
					padding: (BlInsets top: 2 bottom: 2);
					when: BlClickEvent
						do: [ :anEvent | 
							anEvent consumed: true.
							eachGtCoderContextMenuAction action
								cull: self editorElement textualCoderViewModel
								cull: self editorElement
								cull: anEvent.
							self fireEvent: BrDropdownHideWish new.
							self fireEvent: BrContextMenuHideWish new ];
					addChild: (BrLabel new
							aptitude: BrGlamorousLabelAptitude;
							text: (eachGtCoderContextMenuAction title asRopedText
									attributes: {BlFontSizeAttribute size: 12});
							hMatchParent;
							yourself);
					addChild: (BrLabel new
							aptitude: BrGlamorousLabelAptitude;
							text: (eachGtCoderContextMenuAction shortcutKey asRopedText attributes: {BlFontSizeAttribute size: 12});
							hFitContent;
							yourself).
			eachGtCoderContextMenuAction hoverAction
				ifNotNil: [ :hover | 
					element
						when: BlMouseEnterEvent
						do: [ :anEvent | hover cull: self editorElement textualCoderViewModel cull: anEvent ] ].
			eachGtCoderContextMenuAction leaveAction
				ifNotNil: [ :leave | 
					element
						when: BlMouseLeaveEvent
						do: [ :anEvent | leave cull: self editorElement textualCoderViewModel cull: anEvent ] ].
			eachGtCoderContextMenuAction name
				ifNotNil: [ :anActionName | element containerName: anActionName ].
			element ];
		padding: (BlInsets
				top: 8
				right: 10
				bottom: 8
				left: 10);
		hFitContent;
		vFitContent
]
