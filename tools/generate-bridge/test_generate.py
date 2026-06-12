import importlib.util
import unittest


MODULE_PATH = __file__.replace("test_generate.py", "generate.py")


def load_generate_module():
    spec = importlib.util.spec_from_file_location("generate_bridge", MODULE_PATH)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


class MoonBitGenerationTests(unittest.TestCase):
    def setUp(self):
        self.generate = load_generate_module()
        self.spec = self.generate.load_spec()
        self.output = self.generate.render_moonbit(self.spec)

    def test_generated_moonbit_matches_committed_golden(self):
        expected = self.generate.MOONBIT_PATH.read_text(encoding="utf-8")
        self.assertEqual(self.output, expected)

    def test_generated_moonbit_contains_low_level_abi_surface(self):
        required = [
            "generated from api/bridge.json; do not edit",
            "#external\npub type FMLanguageModelSessionRef",
            "pub type FMFeedbackSentiment = Int",
            "pub const FMFeedbackSentimentPositive : FMFeedbackSentiment = 1",
            "pub type FMLanguageModelSessionResponseCallback = UInt",
            "extern \"c\" fn fm_language_model_session_respond(",
            '= "FMLanguageModelSessionRespond"',
            "param callable: callbackPointer: true",
            "returns: ownership: string, nullable: true, pointer: true",
        ]
        for text in required:
            with self.subTest(text=text):
                self.assertIn(text, self.output)


if __name__ == "__main__":
    unittest.main()
