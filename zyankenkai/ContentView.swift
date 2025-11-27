import SwiftUI

struct ContentView: View {
    @State private var cpuHand: Int = -1        // -1: まだ出してない, 0:グー, 1:チョキ, 2:パー
    @State private var myHand: Int  = -1        // -1: 未選択, 0:グー, 1:チョキ, 2:パー
    @State private var gameResult: String = ""  // 結果のメッセージ

    var body: some View {
        VStack {
            Spacer()
            
            // タイトル
            Text("じゃんけんゲーム")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            // CPUの手
            ZStack {
                Color.gray.opacity(0.1)
                    .frame(width: 200, height: 200)
                    .cornerRadius(20)
                
                if cpuHand == -1 {
                    Text("🤖")
                        .font(.system(size: 80))
                } else {
                    // ここを画像ではなく絵文字にしました
                    Text(handEmoji(cpuHand))
                        .font(.system(size: 100))
                }
            }
            .padding()
            
            // 結果表示
            if !gameResult.isEmpty {
                Text(gameResult)
                    .font(.title)
                    .foregroundColor(.red)
                    .fontWeight(.bold)
                    .padding()
            } else {
                Text("手を選んで勝負！")
                    .font(.title2)
                    .foregroundColor(.gray)
                    .padding()
            }
            
            Spacer()
            
            // ユーザーの手選択ボタン
            HStack(spacing: 20) {
                handButton(number: 0, emoji: "✊")
                handButton(number: 1, emoji: "✌️")
                handButton(number: 2, emoji: "✋")
            }
            .padding(.bottom, 30)

            // 勝負ボタン
            Button {
                playGame()
            } label: {
                Text("勝負する！")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(myHand == -1 ? Color.gray : Color.pink)
                    .foregroundColor(.white)
                    .cornerRadius(15)
            }
            .disabled(myHand == -1) // 手を選んでないときは押せない
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
    }
    
    // 手を選ぶボタンの見た目を作る関数
    func handButton(number: Int, emoji: String) -> some View {
        Button {
            myHand = number
            // 手を選び直したら結果とCPUの手をリセット
            gameResult = ""
            cpuHand = -1
        } label: {
            Text(emoji)
                .font(.system(size: 60))
                .frame(width: 80, height: 80)
                .background(myHand == number ? Color.pink.opacity(0.2) : Color.white)
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(myHand == number ? Color.pink : Color.gray.opacity(0.3), lineWidth: 3)
                )
        }
    }
    
    // 数字を絵文字に変換する関数
    func handEmoji(_ number: Int) -> String {
        switch number {
        case 0: return "✊"
        case 1: return "✌️"
        case 2: return "✋"
        default: return ""
        }
    }
    
    // じゃんけんのロジック
    func playGame() {
        // 連続で同じ手が出にくいようにする
        var nextCpu = Int.random(in: 0...2)
        if cpuHand != -1 {
            while nextCpu == cpuHand {
                nextCpu = Int.random(in: 0...2)
            }
        }
        cpuHand = nextCpu
        
        // 勝敗判定
        if myHand == cpuHand {
            gameResult = "あいこです！😲"
        } else if (myHand == 0 && cpuHand == 1) ||
                  (myHand == 1 && cpuHand == 2) ||
                  (myHand == 2 && cpuHand == 0) {
            gameResult = "あなたの勝ち！🎉"
        } else {
            gameResult = "あなたの負け...😭"
        }
    }
}

#Preview {
    ContentView()
}
