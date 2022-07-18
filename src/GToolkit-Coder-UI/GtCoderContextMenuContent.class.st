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
					alignCenter;
					addAptitude: (BrStyleCommonAptitude new
							hovered: [ :aStyle | aStyle background: self theme item selectedColor ]);
					padding: (BlInsets top: 2 bottom: 2);
					addChild: (BrLabel new
							text: eachGtCoderContextMenuAction title asRopedText;
							hMatchParent;
							yourself);
					when: BlClickEvent
						do: [ :anEvent | 
							anEvent consumed: true.
							eachGtCoderContextMenuAction action
								cull: self editorElement textualCoderViewModel
								cull: self editorElement
								cull: anEvent.
							self fireEvent: BrDropdownHideWish new.
							self fireEvent: BrContextMenuHideWish new ].
			eachGtCoderContextMenuAction shortcutKey isEmpty
				ifFalse: [ element
						addChild: (BrHorizontalPane new
								fitContent;
								geometry: (BlRoundedRectangleGeometry cornerRadius: 4);
								border: (BlBorder paint: Color gray width: 1);
								padding: (BlInsets all: 1);
								addChild: (BrLabel new
										text: (eachGtCoderContextMenuAction shortcutKey asRopedText
												fontName: 'Source Code Pro';
												foreground: Color gray;
												fontSize: 10);
										hFitContent;
										yourself);
								yourself) ].
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
